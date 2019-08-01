//
//  Dictionary+UnsafeMerge.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// Merges the given dictionary into this dictionary, BUT WITHOUT a combining
    /// closure to determine the value for any duplicate keys.
    ///
    /// By using this function it suppose you don't have duplicated keys in your dictionaries
    ///
    /// If conflict exist it takes the first value
    ///
    /// - Parameters:
    ///   - other:  A dictionary to merge.
    
    public mutating func merge(_ other: [Dictionary.Key : Dictionary.Value]) {
        self.merge(other) { (value1, _) -> Value in
            return value1
        }
    }
}
