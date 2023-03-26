//
//  HomeRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import RxSwift
import RxCocoa


//레포지토리 에러 타입 정의
enum RepositoryError:Error{
    case success
    case fail
}
protocol HomeRepository{
    func getMain() -> Single<GetMainResponse> //  Single<Result<GetMainResponse, NetworkError>>

    func getMainSoldout(term : String) -> Single<GetMainSoldoutNFTResponse>
    
}
