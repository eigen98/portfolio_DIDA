//
//  SocialInteractionRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/01.
//

import Foundation

protocol SocialInteractionRepository {
    func likeNFT(nftId: Int, completion: @escaping (Result<Bool, Error>) -> ())
    
    func followUser(memberId: Int, completion: @escaping (Result<Bool, Error>) -> ())
}
