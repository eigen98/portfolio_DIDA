//
//  RSAEncryptionService.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/19.
//

import Foundation
import Security

class RSAEncryptionService: EncryptionService {
    
    func encryptWithPublicKey(message: String, publicKeyString: String) -> String? {
        guard let publicKeyData = Data(base64Encoded: publicKeyString),
              let publicKey = publicKeyFromData(publicKeyData),
              let messageData = message.data(using: .utf8) else {
            print("오류: 잘못된 입력 데이터 또는 공개 키.")
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, algorithm, messageData as CFData, &error) else {
            print("암호화 실패: \(error?.takeRetainedValue().localizedDescription ?? "알 수 없는 오류")")
            return nil
        }
        
        return (encryptedData as Data).base64EncodedString()
    }
    
    private func publicKeyFromData(_ data: Data) -> SecKey? {
        let keyDict: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 2048,
            kSecReturnPersistentRef: true
        ]
        
        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(data as CFData, keyDict as CFDictionary, &error) else {
            print("공개 키 생성 실패: \(error?.takeRetainedValue().localizedDescription ?? "알 수 없는 오류")")
            return nil
        }
        
        return secKey
    }
}
