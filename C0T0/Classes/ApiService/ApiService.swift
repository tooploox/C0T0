//
// Created by Karol Wieczorek on 08.02.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

public typealias RequestDecorator = (ApiRequest) -> ApiRequest

public struct RequestConfiguration {
    let numberOfRetries: Int

    init(numberOfRetries: Int = 0) {
        self.numberOfRetries = numberOfRetries
    }

    public static let standard = RequestConfiguration()
}

public struct SessionConfiguration {

    let host: String
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    let requestDecorator: RequestDecorator
    let loggingEnabled: Bool

    public init(host: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, loggingEnabled: Bool = false, requestDecorator: @escaping RequestDecorator = { $0 }) {
        self.host = host
        self.keyDecodingStrategy = keyDecodingStrategy
        self.requestDecorator = requestDecorator
        self.loggingEnabled = loggingEnabled
    }
}

public class ApiService {

    private let configuration: SessionConfiguration

    private let sender: Sender
    private let downloader: Downloader

    public init(configuration: SessionConfiguration) {
        self.configuration = configuration

        let apiDataSource = URLSessionApiDataSource(
            urlRequestBuilder: StandardURLRequestBuilder(host:configuration.host),
            urlRequestSender: StandardURLRequestSender(urlSession: URLSession.shared),
            converter: StandardURLRequestSenderErrorConverter(),
            configuration: ApiDataSourceConfiguration(keyDecodingStrategy: configuration.keyDecodingStrategy, loggingEnabled: configuration.loggingEnabled)
        )

        sender = Sender(apiDataSource: apiDataSource, requestDecorator: configuration.requestDecorator)
        downloader = Downloader(apiDataSource: apiDataSource)
    }

    open func send<T: Decodable>(request: ApiRequest, configuration: RequestConfiguration = .standard, completion: @escaping (Result<T, ApiError>) -> Void) {
        sender.send(request: request, configuration: configuration, completion: completion)
    }

    open func download(from url: URL, configuration: RequestConfiguration = .standard, completion: @escaping (Result<Data, ApiError>) -> Void) {
        downloader.download(fromURL: url, configuration: configuration, completion: completion)
    }
}
