//
//  SearchService.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 8/1/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

class SearchService {
    
    //swiftlint:disable function_parameter_count
    //swiftlint:disable cyclomatic_complexity
    @discardableResult
    func iTunesSearch(item: String,
                      options: SearchOptions?,
                      callback: @escaping ResultCallback<SearchResult>) -> URLSessionDataTask? {
        
        var params: JSONDict = [
            "term": item
        ]
        if let options = options {
           params["media"] = options.media.mediaName
           params["limit"] = "\(options.resultsLimit)"
        }
        return ItunesSearchNetworkClient.request(endpoint: .search,
                                        parameters: params) { (result) in
                                            switch result {
                                            case .success(data: let data):
                                                guard let data_ = data else {
                                                    callback(.success(SearchResult(resultCount: 0, results: [])))
                                                    return
                                                }
                                                guard let result = JSONDecoder.decodeServerResponse(SearchResult.self, from: data_, errorCallback: callback) else { return }
                                                callback(.success(result))
                                            case .error(let error):
                                                callback(.failure(error))
                                            }
        }
    }
}
