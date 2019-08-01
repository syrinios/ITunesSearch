//
//  JSONDecoder+Utils.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var serverDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter.fullDate)
        return decoder
    }()
    
    static func decodeServerResponse<T, ResponseType>(_ type: T.Type, from data: Data?, errorCallback: ResultCallback<ResponseType>) -> T? where T : Decodable {
        do {
            let object = try JSONDecoder.serverDecoder.decode(T.self, from: data ?? Data())
            return object
        } catch {
            LOG("Decoding error:\n\(error.localizedDescription)", .error)
            errorCallback(.failure(ItunesSearchError.encodingError))
            return nil
        }
    }
}
