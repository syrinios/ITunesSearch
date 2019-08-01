//
//  NetworkClient.swift
//  ITunesSearch
//
//  Created by Syrine Ferjani on 7/31/19.
//  Copyright © 2019 Syrine Ferjani. All rights reserved.
//

import Foundation

enum NetworkResult {
    case success(data: Data?)
    case error(Error)
}

enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

typealias NetworkResultCompletion = (NetworkResult) -> Void

class NetworkClient {
    //swiftlint:disable function_parameter_count
    @discardableResult
    public static func request(url: URL,
                               verb: HTTPVerb,
                               httpBody: Data?,
                               headers: [String: String]?,
                               waitingForConnectivity: Bool,
                               completion: @escaping NetworkResultCompletion) -> URLSessionDataTask {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = verb.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpBody = httpBody
        urlRequest.allHTTPHeaderFields = headers
        return self.request(urlRequest,
                            waitingForConnectivity: waitingForConnectivity,
                            completion: completion)
    }
    
    @discardableResult
    public static func request(_ request: URLRequest,
                               waitingForConnectivity: Bool,
                               completion: @escaping NetworkResultCompletion) -> URLSessionDataTask {
        self.log(request: request)
        var session: URLSession!
        if waitingForConnectivity {
            session = self.sessionWaitingForConnectivity
        } else {
            session = self.session
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            self.handle(response: response, data: data, error: error, completion: completion)
        }
        task.resume()
        return task
    }
    
    private static func handle(response: URLResponse?,
                               data: Data?,
                               error: Error?,
                               completion: @escaping NetworkResultCompletion) {
        self.log(response: response, data: data, error: error)
        if let error = error {
            guard (error as NSError).code != NSURLErrorCancelled else {
                // the request was cancelled by the user, forget about it
                return
            }
            self.dispatchToMainThread(result: .error(error),
                                      completion: completion)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            self.dispatchToMainThread(result: .error(ItunesSearchError.unknown),
                                      completion: completion)
            return
        }
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            let error = ItunesSearchError.serverError(code: httpResponse.statusCode,
                                             message: ItunesSearchErrorsDecoder.errorMessage(responseData: data))
            self.dispatchToMainThread(result: .error(error),
                                      completion: completion)
            return
        }
        var dataResult: Data? = nil
        if let data_ = data, !data_.isEmpty {
            dataResult = data_
        }
        self.dispatchToMainThread(result: .success(data: dataResult),
                                  completion: completion)
    }
    
    // MARK: - Thread Helper
    private static func dispatchToMainThread(result: NetworkResult,
                                             completion: @escaping NetworkResultCompletion) {
        if Thread.current == Thread.main {
            completion(result)
        } else {
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

// Session configurations
extension NetworkClient {
    
    static var sessionWaitingForConnectivity: URLSession = {
        let sessionConfiguration = NetworkClient.commonSessionConfiguration()
        if #available(iOS 11, *) {
            sessionConfiguration.waitsForConnectivity = true
            sessionConfiguration.timeoutIntervalForResource = 300
        }
        return URLSession(configuration: sessionConfiguration)
    }()
    
    static var session: URLSession = {
        let sessionConfiguration = NetworkClient.commonSessionConfiguration()
        return URLSession(configuration: sessionConfiguration)
    }()
    
    static private func commonSessionConfiguration() -> URLSessionConfiguration {
        let sessionConfiguration = URLSessionConfiguration.default
        return sessionConfiguration
    }
}

// MARK: - Log helpers
extension NetworkClient {
    static func log(request: URLRequest) {
        #if FILDISTR
        #else
        let bodyString = String(data: request.httpBody ?? Data(), encoding: .utf8)
        LOG("""
            Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")
            Body: \(bodyString ?? "")
            Headers: \(request.allHTTPHeaderFields ?? [:])
            """, .request)
        #endif
    }
    
    static func log(response: URLResponse?, data: Data?, error: Error?) {
        #if FILDISTR
        #else
        if let error = error {
            LOG("Response: \(error.localizedDescription)", .error)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let emoji = httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 ? Logger.LogCategory.success : Logger.LogCategory.error
        let bodyString = String(data: data ?? Data(), encoding: .utf8)
        LOG("""
            Response: \(httpResponse.statusCode)
            Body: \(bodyString ?? "")
            """, emoji)
        #endif
    }
}
