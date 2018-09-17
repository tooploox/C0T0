//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

protocol URLRequestBuilder {
    func build(from request: ApiRequest) -> URLRequest?
}

class StandardURLRequestBuilder: URLRequestBuilder {
    private let host: String

    init(host: String) {
        self.host = host
    }

    func build(from request: ApiRequest) -> URLRequest? {
        guard var components = URLComponents(string: host) else { return nil }

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
