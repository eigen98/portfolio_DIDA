//
//  NetworkError.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
struct NetworkError: Error {
    let statusCode: Int
    let message: String
}
