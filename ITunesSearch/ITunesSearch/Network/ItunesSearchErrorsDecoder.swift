//
//  ItunesSearchErrorsDecoder.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

class ItunesSearchErrorsDecoder {
    static func errorMessage(responseData: Data?) -> String? {
        guard let data = responseData else {
            return nil
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDict = json as? JSONDict else { return nil }
            return jsonDict["err_msg"] as? String
        } catch {
            LOG("Problem while decoding error message: \(error.localizedDescription)")
            return nil
        }
    }
}
