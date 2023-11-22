//
//  CoinTransactionRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/11/22.
//

import Foundation

protocol CoinTransactionRepository {
    func swapKlayToDida(payPwd: String, coin: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func swapDidaToKlay(payPwd: String, coin: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}
