//
// Created by Karolina Samorek on 06/02/2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

public protocol URLRequestSenderErrorConverter {
    func convert(urlSessionSenderError: URLRequestSenderError) -> ApiError
}

final class StandardURLRequestSenderErrorConverter: URLRequestSenderErrorConverter {

    func convert(urlSessionSenderError: URLRequestSenderError) -> ApiError {
        switch(urlSessionSenderError) {
        case .network:
            return .network
        case .http(let statusCode):
            return .http(statusCode)
        }
    }
}