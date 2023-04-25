//
//  UserSessionInterface.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

protocol UserSessionInterface {
    func loginWithKakao(completion: @escaping (String?, Error?) -> Void)
}
