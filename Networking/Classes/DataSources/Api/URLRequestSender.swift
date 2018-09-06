//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public enum UrlRequestSenderError: Error {
    case authorization
    case unprocessableError(Data?)
    case http(Int)
    case network(Error?)
}

public protocol URLRequestSender {
    func send(urlRequest: URLRequest, completion: @escaping (Data?, UrlRequestSenderError?) -> Void)
    func download(url: URL, completion: @escaping (Data?, UrlRequestSenderError?) -> Void)
}

public class StandardURLRequestSender: URLRequestSender {

    public init() {
    }
    
    public func send(urlRequest: URLRequest, completion: @escaping (Data?, UrlRequestSenderError?) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(nil, .network(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                fatalError("Response must be HTTPURLResponse")
            }

            switch response.statusCode {
                case 401:
                    completion(data, .authorization)
                case 422:
                    completion(data, .unprocessableError(data))
                case 200...299:
                    completion(data, nil)
                default:
                    completion(data, .http(response.statusCode))
            }
        }
        task.resume()
    }

    public func download(url: URL, completion: @escaping (Data?, UrlRequestSenderError?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, .network(error))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                fatalError("Response must be HTTPURLResponse")
            }

            switch response.statusCode {
                case 401:
                    completion(data, .authorization)
                case 422:
                    completion(data, .unprocessableError(data))
                case 200...299:
                    completion(data, nil)
                default:
                    completion(data, .http(response.statusCode))
            }
        }
        task.resume()
    }
}
