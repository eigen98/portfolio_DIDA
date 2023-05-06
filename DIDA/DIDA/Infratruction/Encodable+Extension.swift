//
//  Encodable+Extension.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import Foundation

extension Encodable {
    
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}
