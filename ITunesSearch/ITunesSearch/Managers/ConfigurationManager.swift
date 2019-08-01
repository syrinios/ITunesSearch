//
//  ConfigurationManager.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

class ConfigurationManager {
    
    private let defaultEnvironmentKey = "prod"
    
    lazy var currentConfiguration: Configuration = {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json") else {
            fatalError("Unable to load environment from config file")
        }
        do {
            let environmentData = try Data(contentsOf: url)
            let configuration = try JSONDecoder().decode(Configuration.self, from: environmentData)
            return configuration
        } catch {
            fatalError("Unable to read environment data:\n \(error.localizedDescription)")
        }
    } ()
}
