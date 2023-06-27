//
//  HomeRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeRepository {
    func getMain(completion: @escaping (Result<GetMainResponse, Error>) -> ())
    func getMainSoldout(term: String, completion: @escaping (Result<[GetMainSoldoutNFTResponse], Error>) -> ())
}
