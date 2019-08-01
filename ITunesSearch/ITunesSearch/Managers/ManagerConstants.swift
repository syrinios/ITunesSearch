//
//  ManagerConstants.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

typealias JSONDict = [String : Any]
typealias VoidBlock = () -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}

typealias ResultCallback<T> = (Result<T>) -> Void

public enum LoadingState<T>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(Error)
    
    public static func == (rhs: LoadingState, lhs: LoadingState) -> Bool {
        switch (rhs, lhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.loaded, .loaded),
             (.error, .error):
            return true
        default:
            return false
        }
    }
}
