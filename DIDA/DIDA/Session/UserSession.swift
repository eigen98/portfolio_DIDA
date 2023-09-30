//
//  UserSession.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift
import RxOptional
import RxRelay
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class UserSession: UserSessionInterface {
    
    static let shared = UserSession()
    
    private let disposeBag = DisposeBag()
    
    private let user = BehaviorRelay<UserEntity?>(value: nil)
    
    private init() { }
    
    public var userEntity: UserEntity? {
        get {
            self.user.value
        }
    }
    
    public var userEntityObservable: Observable<UserEntity?> {
        get {
            self.user.asObservable()
        }
    }
    
    func initialize() {
        Token.shared.initialize()
        KakaoSDK.initSDK(appKey: SecretConstant.kakaoKey)
        
        Token.shared.tokenObservable.map { $0?.accessToken }.distinctUntilChanged().bind { [weak self] didaToken in
            guard let `self` = self else { return }
            
            if didaToken == nil {
                self.user.accept(nil)
            } else {
                self.fetchMyself()
            }
        }.disposed(by: self.disposeBag)
    }
    
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> Void) {
        switch type {
        case .apple:
            completion(nil, nil)
        case .kakao:
            loginWithKakao { idToken, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let idToken = idToken else {
                    completion(nil, DidaError.invaildIdToken)
                    return
                }
                
                self.socialLogin(type: .kakao, idToken: idToken) { entity, error in
                    
                    completion(entity, error)
                }
            }
        }
    }
    
    private func loginWithApple(completion: @escaping (String?, Error?) -> Void) {
        completion(nil, nil)
    }
    
    private func loginWithKakao(completion: @escaping (String?, Error?) -> Void) {
        
        // 카카오 간편 로그인 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            // 카카오 간편 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(oauthToken?.accessToken, nil)
            }
        } else {
            
            // App-to-App
            UserApi.shared.certLoginWithKakaoAccount(prompts: [.Login]) { certToken, error in
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(certToken?.token.accessToken, nil)
            }
        }
    }
    
    func socialLogin(type: SocialType, idToken: String, completion: @escaping (LoginProviderEntity?, Error?) -> ()) {
        APIClient.request(.socialLogin(request: LoginRequestDTO(type: type, idToken: idToken)))
            .asObservable()
            .flatMapLatest { response -> Observable<LoginProviderEntity> in
                guard response.statusCode == 200 else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
                
                if let decode = try? response.map(SocialLoginResponseDTO.self) {
                    Token.shared.set(accessToken: decode.accessToken ?? "",
                                     refreshToken: decode.refreshToken ?? "")
                    return .just(LoginProviderEntity(isFirst: false))
                }
                
                if let decode = try? response.map(FirstLoginResponseDTO.self) {
                    let email = decode.message.components(separatedBy: " ").last ?? ""
                    return .just(LoginProviderEntity(email: email, isFirst: true))
                }
                
                return .error(DidaError.Unknown)
            }
            .subscribe(onNext: { entity in
                completion(entity, nil)
            }, onError: { error in
                completion(nil, error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func signup(email: String, nickname: String, completion: @escaping (Error?) -> ()) {
        APIClient.request(.signup(request: .init(email: email, nickname: nickname)))
            .asObservable()
            .flatMapLatest { response -> Single<SignupResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(SignupResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                
                Token.shared.set(accessToken: response.accessToken, refreshToken: response.refreshToken)
                
                completion(nil)
            } onError: { error in
                completion(error)
            }.disposed(by: self.disposeBag)

    }
    
    func logout() {
        Token.shared.remove()
        self.user.accept(nil)
    }
    
    func fetchMyself() {
        APIClient.request(.fetchMyself)
            .asObservable()
            .flatMap { response -> Single<UserResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(UserResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                let entity = response.toEntity()
                
                self.user.accept(entity)
            } onError: { error in
                print(error)
                
                // TODO: token 갱신
                Token.shared.remove()
                self.user.accept(nil)
            }.disposed(by: self.disposeBag)

    }
}
