//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public struct ApiDataSourceConfiguration {
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy

    init(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) {
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}

public class URLSessionApiDataSource: ApiDataSource {

    private let urlRequestBuilder: URLRequestBuilder
    private let urlRequestSender: URLRequestSender
    private let errorConverter: URLRequestSenderErrorConverter
    private let jsonDecoder: JSONDecoder

    public init(
        urlRequestBuilder: URLRequestBuilder,
        urlRequestSender: URLRequestSender,
        converter: URLRequestSenderErrorConverter,
        configuration: ApiDataSourceConfiguration) {

        self.urlRequestBuilder = urlRequestBuilder
        self.urlRequestSender = urlRequestSender
        self.errorConverter = converter
        self.jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = configuration.keyDecodingStrategy
    }

    public func send<T: Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        guard let request = urlRequestBuilder.build(from: request) else {
            completion(.failure(.cannotBuildRequest))
            return
        }
        
        urlRequestSender.send(urlRequest: request) { [errorConverter, jsonDecoder] data, error in
            if let error = error {
                completion(.failure(errorConverter.convert(urlSessionSenderError: error)))
            } else if let data = data {
                do {
                    let sanitizedData = data.isEmpty ? "{}".data(using: .utf8)! : data
                    let object = try jsonDecoder.decode(T.self, from: sanitizedData)
                    completion(.success(object))
                } catch let error {
                    completion(.failure(.cannotParseData(error.localizedDescription)))
                }
            } else {
                fatalError("This should not happen")
            }
        }
    }

    public func download(fromURL url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
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

