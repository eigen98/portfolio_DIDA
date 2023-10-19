//
//  EncryptionService.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/19.
//

import Foundation

protocol EncryptionService {
    func encryptWithPublicKey(message: String, publicKeyString: String) -> String?
}
