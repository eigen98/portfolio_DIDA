//
//  UserRepository.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift

protocol UserRepository {
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> ())
    func signup(email: String, nickname: String, completion: @escaping (Error?) -> ())
    func duplicatedNickname(nickname: String, completion: @escaping (Bool?, Error?) -> ()) 
    
    func isLogin() -> Bool
    
    func fetchMyself() -> UserEntity?
    func fetchMyselfObservable() -> Observable<UserEntity?>
    
    func checkWalletExistence(completion: @escaping (Bool?, Error?) -> ())
    func issueWallet(payPwd: String, checkPwd: String, completion: @escaping (Bool?, Error?) -> ())
    func fetchPublicKey(completion: @escaping (String?, Error?) -> ())
}
