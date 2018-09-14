//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

struct ApiDataSourceConfiguration {
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    let loggingEnabled: Bool

    init(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, loggingEnabled: Bool = false) {
        self.keyDecodingStrategy = keyDecodingStrategy
        self.loggingEnabled = loggingEnabled
    }
}

final class URLSessionApiDataSource: ApiDataSource {

    private let urlRequestBuilder: URLRequestBuilder
    private let urlRequestSender: URLRequestSender
    private let errorConverter: URLRequestSenderErrorConverter
    private let jsonDecoder: JSONDecoder
    private let logger: Logger
    
    init(
        urlRequestBuilder: URLRequestBuilder,
        urlRequestSender: URLRequestSender,
        converter: URLRequestSenderErrorConverter,
        configuration: ApiDataSourceConfiguration) {

        self.urlRequestBuilder = urlRequestBuilder
        self.urlRequestSender = urlRequestSender
        self.errorConverter = converter
        self.jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = configuration.keyDecodingStrategy
        logger = Logger(loggingEnabled: configuration.loggingEnabled)
    }

    func send<T: Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        guard let request = urlRequestBuilder.build(from: request) else {
            completion(.failure(.cannotBuildRequest))
            return
        }
        
        logger.log(request)
        
        urlRequestSender.send(urlRequest: request) { [logger, errorConverter, jsonDecoder] data, error in
            logger.log(data)
           
            if let error = error {
                let apiError = (errorConverter.convert(urlSessionSenderError: error))
                completion(.failure(apiError))
                logger.log(apiError)
            } else if let data = data {
                do {
                    let sanitizedData = data.isEmpty ? "{}".data(using: .utf8)! : data
                    let object = try jsonDecoder.decode(T.self, from: sanitizedData)
                    completion(.success(object))
                } catch let error {
                    let apiError = ApiError.cannotParseData(error.localizedDescription)
                    logger.log(apiError)
                    completion(.failure(apiError))
                }
            } else {
                fatalError("This should not happen")
            }
        }
    }

    func download(fromURL url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
        urlRequestSender.download(url: url) { [errorConverter] data, error in
            if let error = error {
                completion(.failure(errorConverter.convert(urlSessionSenderError: error)))
            } else if let data = data {
                completion(.success(data))
            } else {
                fatalError("This should not happen")
            }
        }
    }
}
