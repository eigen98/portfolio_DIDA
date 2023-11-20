//
//  CoinEntity.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/11/20.
//

import Foundation

struct CoinEntity {
    enum CoinType: String {
        case klay = "Klay"
        case dida = "Dida"
    }

    var type: CoinType
    var amount: Double
}
