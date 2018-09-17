//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

protocol URLRequestBuilder {
    func build(from request: ApiRequest) -> URLRequest?
}

class StandardURLRequestBuilder: URLRequestBuilder {
    private enum Constants {
        static let http = "http"
        static let https = "https"
        static let slashes = "://"
        static let httpProtocol = Constants.http + Constants.slashes
        static let httpsProtocol = Constants.https + Constants.slashes
    }
    
    private let host: String
    private let scheme: String
    init(host: String) {
        var host = host
        var scheme = ""
        if host.contains(Constants.httpProtocol) {
            host = host.replacingOccurrences(of:Constants.httpProtocol , with: "")
            scheme = Constants.http
        } else if host.contains(Constants.httpsProtocol) {
            host = host.replacingOccurrences(of: Constants.httpsProtocol, with: "")
            scheme = Constants.https
        }
        self.host = host
        self.scheme = scheme
    }

    func build(from request: ApiRequest) -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = request.endpoint
        components.queryItems = request.urlParameters?.map { URLQueryItem(name: "\($0.key)", value: "\($0.value)") }
    
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = request.method.toString()
        urlRequest.httpBody = request.httpBody
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        return urlRequest
    }
}
