//
//  DataSourcable.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

protocol DataSourcable {
    associatedtype TableItem
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func item(indexPath: IndexPath) -> TableItem
}

enum TableAction {
    case delete
    case reload
    case add
}
