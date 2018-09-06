//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public protocol URLRequestBuilder {
    func build(from request: ApiRequest) -> URLRequest
}

public class StandardURLRequestBuilder: URLRequestBuilder {

    private let scheme: String
    private let host: String
    private let pathPrefix: String

    public init(scheme: String, host: String, pathPrefix: String) {
        self.scheme = scheme
        self.host = host
        self.pathPrefix = pathPrefix
    }

    public func build(from request: ApiRequest) -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = pathPrefix + request.endpoint

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = request.method.toString()
        if let parameters = request.parameters, let body = (try? JSONSerialization.data(withJSONObject: parameters)) {
            urlRequest.httpBody = body
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        return urlRequest
    }
}
