//
//  ApplicationStorage.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/21.
//

import Foundation

enum ApplicationStorageKeys: String {
    case isFirst = "first_install"
}

/// [docs] 어플리케이션 단으로 저장되는 값들을 관리합니다.
/// ApplicationStorageKeys:: UserDefaults의 키 값
/// set 과 read는 return type에 따라 공통적으로 사용한다.
/// e.x. key: isFrist, isFirstRegiste .. -> Bool
class ApplicationStorage {
    static public let shared = ApplicationStorage()
    
    private init() { }
    
    func set(_ key: ApplicationStorageKeys, value: Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func read(_ key: ApplicationStorageKeys, defaultValue: Bool = false) -> Bool {
        if let value = UserDefaults.standard.object(forKey: key.rawValue) as? Bool {
            return value
        } else {
            return defaultValue
        }
    }
}
