//
//  HomeRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeRepository{
    //14 메인 화면 가져오기(판매완료 없음)
    func getMain() -> Single<GetMainResponse> //  Single<Result<GetMainResponse, NetworkError>>

    //15. 홈화면 판매 완료 메인화면 가져오기 //term : 7, 30, 60, 365
    func getMainSoldout(term : String) -> Single<[GetMainSoldoutNFTResponse]>
    
}
