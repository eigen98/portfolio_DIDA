//
//  PaymentPasswordInterface.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/11/05.
//

import Foundation
import RxSwift

struct DIDAPassword: Codable {
    let password: String
}

protocol PaymentPasswordInterface {
    func initialize()
    func set(password: String)
    func remove()
    func read() -> DIDAPassword?
}
