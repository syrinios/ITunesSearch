//
//  Configuration.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

struct Configuration: Codable {
    
    struct Api: Codable {
        let itunesSearchApi: URL
        let publicKey: String
        let privateKey: String
    }
    
    let api: Api
    
    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
