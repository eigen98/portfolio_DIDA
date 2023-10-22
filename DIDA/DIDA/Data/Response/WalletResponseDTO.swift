//
//  WalletResponseDTO.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/21.
//

import Foundation
struct WalletResponseDTO: Decodable {
    let address: String?
    let klay: Double?
    let dida: Double?
}
