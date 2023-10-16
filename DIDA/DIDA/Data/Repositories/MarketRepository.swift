//
//  MarketRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/29.
//

import Foundation

protocol MarketRepository {
    func getNFTDetail(nftId: Int, completion: @escaping (Result<GetNFTDetailResponse, Error>) -> ())
    
    func purchaseNFT(payPwd: String, marketId: Int, completion: @escaping (Result<PurchaseNFTResponse, Error>) -> ())
}
