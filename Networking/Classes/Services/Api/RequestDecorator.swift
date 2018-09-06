//
// Created by Karol Wieczorek on 05.02.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

extension StandardApiService {

    class RequestDecorator {

        private let authenticationTokenBuilder: AuthenticationTokenBuilder

        init(authenticationTokenBuilder: AuthenticationTokenBuilder) {
            self.authenticationTokenBuilder = authenticationTokenBuilder
        }

        func decorate(request: ApiRequest) -> ApiRequest {
            var headers = request.headers ?? [:]
            headers["Authorization"] = authenticationTokenBuilder.authenticationToken

            return ApiRequest(
                endpoint: request.endpoint,
                method: request.method,
                parameters: request.parameters,
                headers: headers
            )
        }
    }
}
