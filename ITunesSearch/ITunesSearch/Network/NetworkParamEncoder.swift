//
//  NetworkParamEncoder.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

enum NetworkBodyEncoding {
    case json
    case urlParams
}

class NetworkParamEncoder {
    
    private let body: [String: Any]
    private let encoding: NetworkBodyEncoding
    
    init(body: [String: Any], encoding: NetworkBodyEncoding) {
        self.body = body
        self.encoding = encoding
    }
    
    func encodeToData() throws -> Data {
        switch self.encoding {
        case .json:
            return try JSONSerialization.data(withJSONObject: body, options: [])
        case .urlParams:
            fatalError("Can't encode url params to data")
        }
    }
    
    func encodeToQueryItems() -> [URLQueryItem] {
        switch self.encoding {
        case .json:
            fatalError("Can't encode url params to JSON")
        case .urlParams:
            return self.body.compactMap({
                var value = String(describing: $1)
                if let arrayValue = $1 as? [Any] {
                    value = arrayValue.map({ String(describing: $0) }).joined(separator: ",")
                }
                return URLQueryItem(name: $0, value: value)
            })
        }
    }
}
