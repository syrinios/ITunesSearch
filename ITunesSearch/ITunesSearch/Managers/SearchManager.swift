//
//  SearchManager.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

class SearchManager {
    var item: String
    var options: SearchOptions?
    
    private let searchService = SearchService()
    private var searchInfosCache = [Int: SearchItem?]()
    private var itemSearchDataTask: URLSessionDataTask?
    
    init(item: String, options: SearchOptions?) {
        self.item = item
        self.options = options
    }
    
    func searchItems(callback: @escaping ResultCallback<SearchResult>) {
        self.itemSearchDataTask?.cancel()

        self.itemSearchDataTask = self.searchService.iTunesSearch(item: item, options: options, callback: { (result) in
            switch result {
            case .success(let itemList):
                callback(.success(itemList))
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
}
