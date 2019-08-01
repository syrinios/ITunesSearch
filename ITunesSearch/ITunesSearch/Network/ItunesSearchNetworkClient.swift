//
//  ItunesSearchNetworkClient.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

class ItunesSearchNetworkClient: NetworkClient {
    
    static var apiConfiguration: Configuration.Api = {
        let configurationManager = ConfigurationManager()
        return configurationManager.currentConfiguration.api
    }()
    
    @discardableResult
    static public func request(endpoint: ItunesSearchEndpoint,
                               parameters: [String: Any],
                               completion: @escaping NetworkResultCompletion) -> URLSessionDataTask? {
        var params = ItunesSearchNetworkClient.sharedParams(endpoint: endpoint)
        params.merge(parameters)
        var body: Data?
        var queryItems: [URLQueryItem]?
        switch endpoint.verb {
        case .get, .delete:
            let paramsEncoder = NetworkParamEncoder(body: params,
                                                    encoding: .urlParams)
            queryItems = paramsEncoder.encodeToQueryItems()
        default:
            let paramsEncoder = NetworkParamEncoder(body: params,
                                                    encoding: .json)
            do {
                body = try paramsEncoder.encodeToData()
            } catch {
                completion(.error(ItunesSearchError.encodingError))
            }
        }
        
        var url = self.url(for: endpoint)
        url.appendPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        
        guard let finalUrl = components?.url else {
            completion(.error(ItunesSearchError.unknown))
            return nil
        }
        
        let headers = [
            "Accept": endpoint.acceptHeader
        ]
        
        return self.request(url: finalUrl,
                            verb: endpoint.verb,
                            httpBody: body,
                            headers: headers,
                            waitingForConnectivity: endpoint.waitingForConnectivity,
                            completion: completion)
    }
    
    @discardableResult
    static public func request(endpoint: ItunesSearchEndpoint,
                               parameters: Data,
                               completion: @escaping NetworkResultCompletion) -> URLSessionDataTask {
        var url = self.url(for: endpoint)
        url.appendPathComponent(endpoint.path)
        return self.request(url: url,
                            verb: endpoint.verb,
                            httpBody: parameters,
                            headers: nil,
                            waitingForConnectivity: endpoint.waitingForConnectivity,
                            completion: completion)
    }
    
    static func url(for endpoint: ItunesSearchEndpoint) -> URL {
        switch endpoint.access {
        default:
            return self.apiConfiguration.itunesSearchApi
        }
    }
    
    private static func sharedParams(endpoint: ItunesSearchEndpoint) -> JSONDict {
        var params = JSONDict()
        switch endpoint.access {
        case .publicAccess:
            params["key"] = self.apiConfiguration.publicKey
        case .privateAccess:
            params["key"] = self.apiConfiguration.privateKey
        }
        return params
    }
}
