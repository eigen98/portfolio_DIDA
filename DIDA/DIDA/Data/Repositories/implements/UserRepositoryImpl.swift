//
//  UserRepositoryImpl.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift
import Moya

class UserRepositoryImpl: UserRepository {
    
    private let disposeBag = DisposeBag()
    
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> ()) {
        UserSession.shared.login(type: type) { entity, error in
            completion(entity, error)
        }
    }
    
    func signup(email: String, nickname: String, completion: @escaping (Error?) -> ()) {
        UserSession.shared.signup(email: email, nickname: nickname) { error in
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func isLogin() -> Bool {
        return UserSession.shared.userEntity != nil
    }
    
    func fetchMyself() -> UserEntity? {
        return UserSession.shared.userEntity
    }
    
    func fetchMyselfObservable() -> Observable<UserEntity?> {
        return UserSession.shared.userEntityObservable
    }
    
    func duplicatedNickname(nickname: String, completion: @escaping (Bool?, Error?) -> ()) {
        APIClient.request(.duplicatedNickname(request: .init(nickname: nickname)))
            .asObservable()
            .flatMap { response -> Single<DuplicatedNicknameResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(DuplicatedNicknameResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                completion(response.used, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
        
    }
    
    func checkWalletExistence(completion: @escaping (Bool?, Error?) -> ()) {
        APIClient.request(.validateWalletPresence)
            .asObservable()
            .flatMap { response -> Single<WalletExistenceResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(WalletExistenceResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                completion(response.existed, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
    }
    
    func issueWallet(payPwd: String, checkPwd: String, completion: @escaping (Bool?, Error?) -> ()) {
        APIClient.request(.issueWallet(payPwd: payPwd, checkPwd: checkPwd))
            .asObservable()
            .flatMap { response -> Single<Response> in
                if response.statusCode == 200 {
                    return Single.just(response)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                completion(true, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
    }
    
    func fetchPublicKey(completion: @escaping (String?, Error?) -> ()) {
        APIClient.request(.getPublicKey)
            .asObservable()
            .flatMap { response -> Single<PublicKeyResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(PublicKeyResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                completion(response.publicKey, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
    }
    
    func checkPassword(payPwd: String, completion: @escaping (PasswordCheckEntity?, Error?) -> ()) {
        APIClient.request(.checkPassword(payPwd: payPwd))
            .asObservable()
            .flatMap { response -> Single<PasswordCheckResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(PasswordCheckResponseDTO.self)
                    return Single.just(decode)
                } else if response.statusCode == 403 {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    if error.code == "WALLET_006" {
                        return .error(UserRepositoryError.passwordExceededLimit)
                    } else {
                        return .error(UserRepositoryError.apiError(error))
                    }
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(UserRepositoryError.apiError(error))
                }
            }.map { responseDTO in
                return PasswordCheckEntity(matched: responseDTO.matched ?? false,
                                           wrongCount: responseDTO.wrongCnt ?? 0)
            }.subscribe { entity in
                completion(entity, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
    }
    
    func fetchWallet(completion: @escaping (WalletEntity?, Error?) -> ()) {
        APIClient.request(.fetchWallet)
            .asObservable()
            .flatMap { response -> Single<WalletResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(WalletResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.map { responseDTO in
                return WalletEntity(address: responseDTO.address ?? "",
                                    klay: responseDTO.klay ?? 0.0,
                                    dida: responseDTO.dida ?? 0.0)
            }.subscribe { entity in
                completion(entity, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
    }
    
    func sendAuthenticationEmail(completion: @escaping (String?, Error?) -> ()) {
        APIClient.request(.sendVerificationEmail)
            .asObservable()
            .flatMap { response -> Single<VerificationEmailResponseDTO> in
                if response.statusCode == 200 {
                    let decode = try response.map(VerificationEmailResponseDTO.self)
                    return Single.just(decode)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { responseDTO in
                completion(responseDTO.random, nil)
            } onError: { error in
                completion(nil, error)
            }.disposed(by: self.disposeBag)
    }

    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Bool?, Error?) -> ()) {
        APIClient.request(.modifyPassword(nowPwd: oldPassword, changePwd: newPassword))
            .asObservable()
            .flatMap { response -> Single<Response> in
                if response.statusCode == 200 {
                    return Single.just(response)
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    return .error(DidaError.apiError(error))
                }
            }.subscribe { response in
                completion(true, nil)
            } onError: { error in
                completion(false, error)
            }.disposed(by: self.disposeBag)
    }
}
struct VerificationEmailResponseDTO: Decodable {
    let random: String
}
