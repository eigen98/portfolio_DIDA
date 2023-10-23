//
//  UserRepository.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift

enum UserRepositoryError: Error {
    case apiError(BaseErrorResponseDTO)
    case passwordExceededLimit
}

protocol UserRepository {
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> ())
    func signup(email: String, nickname: String, completion: @escaping (Error?) -> ())
    func duplicatedNickname(nickname: String, completion: @escaping (Bool?, Error?) -> ()) 
    
    func isLogin() -> Bool
    
    func fetchMyself() -> UserEntity?
    func fetchMyselfObservable() -> Observable<UserEntity?>
    
    func checkWalletExistence(completion: @escaping (Bool?, Error?) -> ())
    func issueWallet(payPwd: String, checkPwd: String, completion: @escaping (Bool?, Error?) -> ())
    func fetchWallet(completion: @escaping (WalletEntity?, Error?) -> ())
    func fetchPublicKey(completion: @escaping (String?, Error?) -> ())
    
    func checkPassword(payPwd: String, completion: @escaping (PasswordCheckEntity?, Error?) -> ())
    func sendAuthenticationEmail(completion: @escaping (String?, Error?) -> ())
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Bool?, Error?) -> ())
}
