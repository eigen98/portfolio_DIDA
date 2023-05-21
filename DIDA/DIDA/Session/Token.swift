//
//  Token.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/21.
//

import Foundation
import Security
import RxSwift
import RxCocoa

/// [docs]
/// Keychain을 통해 토큰들을 저장 / 삭제 / 수정을 관리하는 클래스
class Token: TokenInterface {
    
    static public let shared = Token()
    
    private let account = "DIDA-Token"
    private let serviceId = Bundle.main.bundleIdentifier!
    
    private let entity = BehaviorRelay<DIDAToken?>(value: nil)
    
    init() {
        self.read()
    }
    
    var accessToken: String? {
        return self.entity.value?.accessToken
    }
    
    var refreshToken: String? {
        return self.entity.value?.refreshToken
    }
    
    func set(accessToken: String, refreshToken: String) {
        let entity = DIDAToken(accessToken: accessToken, refreshToken: refreshToken)
        
        do {
            let data = try JSONEncoder().encode(entity)
            
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: self.serviceId,
                kSecAttrAccount: self.account,
                kSecAttrGeneric: data
            ]
            
            // 기존 토큰 정보를 삭제하고 저장한다.
            self.remove()
            
            let statusCode = SecItemAdd(query as CFDictionary, nil)
            
            if statusCode == errSecSuccess {
                self.entity.accept(entity)
            } else {
                // TODO: error 처리
                print("Token:: faillure:: save:: \(statusCode)")
            }
            
        } catch let error {
            print("Token:: faillure:: decoding \(error)")
        }
        
    }
    
    func remove() {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.serviceId,
            kSecAttrAccount: self.account
        ]
        
        let statusCode = SecItemDelete(query)
        
        if statusCode != noErr {
            self.entity.accept(nil)
        }
    }
    
    private func read() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.serviceId,
            kSecAttrAccount: self.account,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            self.entity.accept(nil)
            return
        }
        
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecAttrGeneric as String] as? Data
        else { return }
        
        let entity = try? JSONDecoder().decode(DIDAToken.self, from: data)
        self.entity.accept(entity)
    }
    
}
