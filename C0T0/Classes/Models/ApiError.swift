//
// Created by Karol on 11.09.2018.
//

import Foundation

public enum ApiError: Error {
    case cannotParseData(String)
    case network
    case http(Int)
    case cannotBuildRequest
}

extension ApiError: Equatable {

    public static func ==(lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
        case (.cannotParseData(let lDescription), .cannotParseData(let rDescription)):
            return lDescription == rDescription
        case (.http(let lCode), .http(let rCode)):
            return lCode == rCode
        case (.network, .network):
            return true
        case (.cannotBuildRequest, .cannotBuildRequest):
            return true
        default:
            return false
        }
    }
}