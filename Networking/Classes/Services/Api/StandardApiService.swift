//
// Created by Karol Wieczorek on 08.02.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

open class StandardApiService: ApiService {

    private let sender: Sender
    private let downloader: Downloader

    public init(apiDataSource: ApiDataSource, authenticationTokenBuilder: AuthenticationTokenBuilder) {
        let requestDecorator = RequestDecorator(authenticationTokenBuilder: authenticationTokenBuilder)
        self.downloader = Downloader(apiDataSource: apiDataSource)
        self.sender = Sender(
            apiDataSource: apiDataSource,
            requestDecorator: requestDecorator
        )
    }

    open func send<T: Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        sender.send(request: request, retries: 3, completion: completion)
    }

    open func send<T: Decodable>(request: ApiRequest, retries: Int, completion: @escaping (Result<T, ApiError>) -> Void) {
        sender.send(request: request, retries: retries, completion: completion)
    }

    open func download(fromURL url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
        downloader.download(fromURL: url, completion: completion)
    }
}
