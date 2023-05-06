//
//  UserSession.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift
import RxRelay
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class UserSession: UserSessionInterface {
    
    static let shared = UserSession()
    
    private let disposeBag = DisposeBag()
    
    private let token = BehaviorRelay<Token?>(value: nil)
    
    private init() { }
    
    func initialize() {
        KakaoSDK.initSDK(appKey: SecretConstant.kakaoKey)
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
                
                completion(oauthToken?.idToken, nil)
            }
        } else {
            
            // App-to-App
            UserApi.shared.certLoginWithKakaoAccount(prompts: [.Login]) { certToken, error in
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(certToken?.token.idToken, nil)
            }
        }
    }
    
    func socialLogin(type: SocialType, idToken: String, completion: @escaping (LoginProviderEntity?, Error?) -> ()) {
        
        APIClient.request(.socialLogin(request: LoginRequestDTO(type: type, idToken: idToken)))
            .asObservable()
            .flatMapLatest { response -> Single<SocialLoginResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(SocialLoginResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
               
            }.subscribe { response in
                
                let accessToken = response.accessToken ?? ""
                let refreshToken = response.refreshToken ?? ""
                
                if accessToken.isEmpty {
                    completion(nil, DidaError.Unknown)
                    return
                }
                
                if refreshToken.isEmpty {
                    completion(LoginProviderEntity(email: response.accessToken, isFirst: true), nil)
                    return
                }
                
                completion(LoginProviderEntity(isFirst: false), nil)
                
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
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
            }.subscribe { [weak self] response in
                guard let `self` = self else { return }
                
                self.token.accept(Token(accessToken: response.accessToken, refreshToken: response.refreshToken))
                completion(nil)
            } onError: { error in
                completion(error)
            }.disposed(by: self.disposeBag)

    }
}
