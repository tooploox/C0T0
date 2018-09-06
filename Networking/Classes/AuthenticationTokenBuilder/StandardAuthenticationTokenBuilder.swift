//
// Created by Karol Wieczorek on 22.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public enum AuthenticationType: String {
    case basic = "Basic"
    case bearer = "Bearer"
}

public class StandardAuthenticationTokenBuilder: AuthenticationTokenBuilder {
    
    public var authenticationToken: String {
        if let token = getToken() as? String {
            return "\(authenticationType.rawValue) \(token)"
        } else {
            return ""
        }
    }

    private let authenticationType: AuthenticationType
    private let getToken: () -> Any?
    
    public init(_ authenticationType: AuthenticationType, getToken: @escaping () -> Any?) {
        self.authenticationType = authenticationType
        self.getToken = getToken
    }
}
