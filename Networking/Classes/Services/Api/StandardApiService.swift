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

    struct URLComponents {
        let scheme: String
        let host: String
        let pathPrefix: String

        init(scheme: String, host: String, pathPrefix: String = "") {
            self.scheme = scheme
            self.host = host
            self.pathPrefix = pathPrefix
        }
    }

    let urlComponents: URLComponents
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    let requestDecorator: RequestDecorator

    init(urlComponents: URLComponents, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, requestDecorator: @escaping RequestDecorator = { $0 }) {
        self.urlComponents = urlComponents
        self.keyDecodingStrategy = keyDecodingStrategy
        self.requestDecorator = requestDecorator
    }
}

public class StandardApiService {

    private let configuration: SessionConfiguration

    private let sender: Sender
    private let downloader: Downloader

    public init(configuration: SessionConfiguration) {
        self.configuration = configuration

        let apiDataSource = URLSessionApiDataSource(
            urlRequestBuilder: StandardURLRequestBuilder(
                scheme: configuration.urlComponents.scheme,
                host: configuration.urlComponents.host,
                pathPrefix: configuration.urlComponents.pathPrefix
            ),
            urlRequestSender: StandardURLRequestSender(urlSession: URLSession.shared),
            converter: StandardURLRequestSenderErrorConverter(),
            configuration: ApiDataSourceConfiguration()
        )

        sender = Sender(apiDataSource: apiDataSource, requestDecorator: configuration.requestDecorator)
        downloader = Downloader(apiDataSource: apiDataSource)

    }

//    public init(apiDataSource: ApiDataSource, authenticationTokenBuilder: AuthenticationTokenBuilder) {
//        let requestDecorator = RequestDecorator(authenticationTokenBuilder: authenticationTokenBuilder)
//        self.downloader = Downloader(apiDataSource: apiDataSource)
//        self.sender = Sender(
//            apiDataSource: apiDataSource,
//            requestDecorator: requestDecorator
//        )
//    }

    open func send<T: Decodable>(request: ApiRequest, configuration: RequestConfiguration = .standard, completion: @escaping (Result<T, ApiError>) -> Void) {
        sender.send(request: request, configuration: configuration, completion: completion)
    }

    open func download(from url: URL, configuration: RequestConfiguration = .standard, completion: @escaping (Result<Data, ApiError>) -> Void) {
        downloader.download(fromURL: url, configuration: configuration, completion: completion)
    }
}
