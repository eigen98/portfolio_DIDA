//
//  HomeEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

struct HomeEntity{
    var getHotItems : [HotItemEntity]
    var getHotSellers : [HotSellerEntity]
    var getRecentCards : [UserNftEntity]
    var getHotUsers : [HotUserEntity]
    
    /*
     DataSource에 넣어줄 로딩 셀 아이템을 생성합니다.
     */
    static func initLoadingItems() -> HomeEntity{
        return HomeEntity(getHotItems: [HotItemEntity.initLoadingEntity()],
                          getHotSellers: [HotSellerEntity.initLoadingEntity()],
                          getRecentCards: [UserNftEntity.initLoadingEntity()],
                          getHotUsers: [HotUserEntity.initLoadingEntity()])
    }
}
