//
//  ItunesSearchEndpoint.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

enum ItunesSearchEndpointAccess {
    case publicAccess
    case privateAccess
}

enum ItunesSearchEndpoint {
    case search
    
    var path: String {
        switch self {
        default:
            return String(describing: self)
        }
    }
    
    var verb: HTTPVerb {
        switch self {
        default:
            return .get
        }
    }
    
    var waitingForConnectivity: Bool {
        switch self {
        default:
            return true
        }
    }
    
    var access: ItunesSearchEndpointAccess {
        switch self {
        default:
            return .publicAccess
        }
    }
    
    var acceptHeader: String {
        switch self {
        default:
            return "application/json"
        }
    }
}
