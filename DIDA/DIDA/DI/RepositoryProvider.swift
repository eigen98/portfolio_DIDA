//
//  RepositoryProvider.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation

final class RepositoryProvider {
    // singleton repositories
   
    static var homeRepo:HomeRepository? = nil
    
    static func getHomeRepository() -> HomeRepository {
        if self.homeRepo == nil {
            self.homeRepo = HomeRepositoryImpl(apiClient: APIClient() )
        }
        return self.homeRepo!
    }
    
}
