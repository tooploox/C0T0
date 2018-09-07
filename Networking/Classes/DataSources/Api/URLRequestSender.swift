//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public enum UrlRequestSenderError: Error, Equatable {
    case http(Int)
    case network(Error)

    public static func ==(lhs: UrlRequestSenderError, rhs: UrlRequestSenderError) -> Bool {
        switch (lhs, rhs) {
        case (.http(let lCode), .http(let rCode)):
            return lCode == rCode
        case (.network, .network):
            return true
        default:
            return false
        }
    }
}

public protocol URLRequestSender {
    func send(urlRequest: URLRequest, completion: @escaping (Data?, UrlRequestSenderError?) -> Void)
    func download(url: URL, completion: @escaping (Data?, UrlRequestSenderError?) -> Void)
}

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }



public class StandardURLRequestSender: URLRequestSender {

    private let urlSession: URLSessionProtocol

    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func send(urlRequest: URLRequest, completion: @escaping (Data?, UrlRequestSenderError?) -> Void) {
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }

    public func download(url: URL, completion: @escaping (Data?, UrlRequestSenderError?) -> Void) {
        let task = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }

    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: (Data?, UrlRequestSenderError?) -> Void) {
        if let error = error {
            completion(nil, .network(error))
            return
        }

        guard let response = response as? HTTPURLResponse else {
            fatalError("Response must be HTTPURLResponse")
        }

        switch response.statusCode {
        case 200...299:
            completion(data, nil)
        default:
            completion(data, .http(response.statusCode))
        }
    }
}
