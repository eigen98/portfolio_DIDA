//
//  PurchaseNFTResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/11.
//

import Foundation
struct PurchaseNFTResponse: Codable {
    let code: String?
    let message: String?
    let timestamp: String?
}

enum PurchaseNFTErrors: Error {
    case passwordMismatch
    case passwordAttemptsExceeded
    case cannotPurchaseOwnNFT
    case insufficientCoin
    case didaCheckFailed
    case didaTransferFailed
    case unauthorized
    case forbidden
    case conflict
    case internalServerError
    case walletNotExist
    case unknownError
    
    init(code: String) {
        switch code {
        case "WALLET_002": self = .passwordMismatch
        case "WALLET_006": self = .passwordAttemptsExceeded
        case "MARKET_004": self = .cannotPurchaseOwnNFT
        case "WALLET_008": self = .insufficientCoin
        case "WALLET_010": self = .didaCheckFailed
        case "WALLET_011": self = .didaTransferFailed
        case "AUTH_001", "AUTH_002", "AUTH_003", "AUTH_004": self = .unauthorized
        case "GLOBAL_006": self = .forbidden
        case "MARKET_001", "WALLET_004": self = .conflict
        default: self = .unknownError
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .passwordMismatch: return "비밀번호가 일치하지 않습니다."
        case .passwordAttemptsExceeded: return "비밀번호를 5번 이상 잘못 입력하였습니다."
        case .cannotPurchaseOwnNFT: return "본인의 NFT는 구매할 수 없습니다."
        case .insufficientCoin: return "보유한 코인이 충분치 않습니다."
        case .didaCheckFailed: return "DIDA 확인에 실패하였습니다."
        case .didaTransferFailed: return "DIDA 전송에 실패하였습니다."
        case .unauthorized: return "인증되지 않았습니다."
        case .forbidden: return "권한이 없습니다."
        case .conflict: return "충돌이 발생했습니다."
        case .internalServerError: return "서버 내부 오류입니다."
        case .unknownError: return "알 수 없는 오류가 발생했습니다."
        case .walletNotExist: return "지갑이 존재하지 않습니다."
        }
    }
}
