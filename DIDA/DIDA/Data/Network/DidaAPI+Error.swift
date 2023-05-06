//
//  DidaAPI+Error.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/05.
//

import Foundation


enum DidaError: Error {
    
    /// social login token error
    case Unknown
    case invaildIdToken
    
    /// api error
    case apiError(BaseErrorResponseDTO)
}
