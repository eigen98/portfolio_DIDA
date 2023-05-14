//
//  UserRepositoryImpl.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift

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
        return UserSession.shared.accessToekn.isNotEmpty
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
}
