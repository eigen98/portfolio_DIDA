//
//  UserSession.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class UserSession: UserSessionInterface {
    
    static let shared = UserSession()
    
    private init() { }
    
    func initialize() {
        KakaoSDK.initSDK(appKey: SecretConstant.kakaoKey)
    }
    
    func loginWithKakao(completion: @escaping (String?, Error?) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(oauthToken?.idToken, nil)
            }
        }
    }
}
