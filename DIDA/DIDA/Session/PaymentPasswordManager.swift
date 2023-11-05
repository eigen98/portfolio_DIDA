//
//  PaymentPasswordManager.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/11/05.
//

import Foundation

/// Keychain을 통해 비밀번호를 저장 / 삭제 / 조회를 관리하는 클래스
class PaymentPasswordManager: PaymentPasswordInterface {
    
    static public let shared = PaymentPasswordManager()
    
    private let account = "DIDA-Password"
    private let serviceId = Bundle.main.bundleIdentifier!
    
    private init() { }
    
    func initialize() {
        let isFirstInstall = ApplicationStorage.shared.read(.isFirst, defaultValue: true)
        
        if isFirstInstall {
            self.remove()
            ApplicationStorage.shared.set(.isFirst, value: false)
        }
    }
    
    func set(password: String) {
        let passwordEntity = DIDAPassword(password: password)
        
        do {
            let data = try JSONEncoder().encode(passwordEntity)
            
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: self.serviceId,
                kSecAttrAccount: self.account,
                kSecValueData: data
            ]
            
            // 기존 비밀번호 정보를 삭제하고 저장한다.
            self.remove()
            
            let statusCode = SecItemAdd(query as CFDictionary, nil)
            
            if statusCode != errSecSuccess {
                // TODO: error 처리
                print("PasswordManager:: failure:: save:: \(statusCode)")
            }
        } catch let error {
            print("PasswordManager:: failure:: encoding \(error)")
        }
    }
    
    func remove() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.serviceId,
            kSecAttrAccount: self.account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func read() -> DIDAPassword? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: self.serviceId,
            kSecAttrAccount: self.account,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: false,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess {
            if let data = item as? Data {
                return try? JSONDecoder().decode(DIDAPassword.self, from: data)
            }
        }
        return nil
    }
}
