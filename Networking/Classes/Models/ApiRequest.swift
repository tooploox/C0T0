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

    let endpoint: String
    let method: HTTPMethod
    let parameters: HTTPParameters?
    let headers: HTTPHeaders?

    public init(endpoint: String, method: HTTPMethod, parameters: HTTPParameters? = nil, headers: HTTPHeaders? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}

extension ApiRequest: Equatable {

    public static func == (lhs: ApiRequest, rhs: ApiRequest) -> Bool {
        let equalParameters: Bool
        switch (lhs.parameters, rhs.parameters) {
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
            equalParameters
    }
}
