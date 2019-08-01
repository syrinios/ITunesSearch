//
//  ItunesSearchError.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

enum ItunesSearchError: LocalizedError {
    case encodingError
    case serverError(code: Int, message: String?)
    case unknown
    case noData
    
    public var errorDescription: String? {
        switch self {
        case .encodingError:
            return "Coding error"
        case .unknown:
            return "Unknown error"
        case .serverError(code: _, message: let message):
            return message ?? "Unknown error"
        case .noData:
            return "No data received"
        }
    }
}
