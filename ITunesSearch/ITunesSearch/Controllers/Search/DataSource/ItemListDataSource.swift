//
//  ItemListDataSource.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

class ItemListDataSource {
    typealias TableItem = SearchItem
    
    private (set) var searchResult: SearchResult
    private (set) var infos: [SearchItem]
    
    init(searchResult: SearchResult) {
        self.searchResult = searchResult
        self.infos = searchResult.results
    }
}

extension ItemListDataSource: DataSourcable {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(section: Int) -> Int {
        return self.infos.count
    }
    
    func item(indexPath: IndexPath) -> SearchItem {
        return infos[indexPath.row]
    }
}
