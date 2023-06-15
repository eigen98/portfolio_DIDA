//
//  TokenInterface.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/21.
//

import Foundation
import RxSwift

struct DIDAToken: Codable {
    let accessToken: String
    let refreshToken: String
}

protocol TokenInterface {
    var tokenObservable: Observable<DIDAToken?> { get }
    var accessToken: String? { get }
    var refreshToken: String? { get }
    
    func initialize()
    func `set`(accessToken: String, refreshToken: String)
    func remove()
}
