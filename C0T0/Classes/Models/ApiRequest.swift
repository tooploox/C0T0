//
// Created by Karol on 11.09.2018.
//

import Foundation

public typealias HTTPParameters = [String: Any]
public typealias HTTPHeaders = [String: String]
typealias JSONDictionary = [String: Any]

public enum HTTPMethod: String, Equatable {
    case GET
    case POST
    case PUT
    case DELETE

    func toString() -> String {
        return rawValue
    }
}

public struct ApiRequest {

    public let endpoint: String
    public let method: HTTPMethod
    public let urlParameters: HTTPParameters?
    public let headers: HTTPHeaders?
    public let httpBody: Data?

    public init(endpoint: String, method: HTTPMethod, urlParameters: HTTPParameters? = nil, httpBody: Data? = nil ,headers: HTTPHeaders? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.urlParameters = urlParameters
        self.headers = headers
        self.httpBody = httpBody
    }
}

extension ApiRequest: Equatable {
    public static func == (lhs: ApiRequest, rhs: ApiRequest) -> Bool {
        let equalParameters: Bool
        switch (lhs.urlParameters, rhs.urlParameters) {
        case (nil, nil):
            equalParameters = true
        case let (leftParameters?, rightParameters?):
            equalParameters = NSDictionary(dictionary: leftParameters).isEqual(to: rightParameters)
        default:
            equalParameters = false
        }
        
        return lhs.endpoint == rhs.endpoint &&
            lhs.method == rhs.method &&
            lhs.headers == rhs.headers &&
            equalParameters &&
            lhs.httpBody == rhs.httpBody
    }
}
