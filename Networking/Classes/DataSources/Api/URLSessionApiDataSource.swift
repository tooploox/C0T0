//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public class URLSessionApiDataSource: ApiDataSource {

    private let urlRequestBuilder: URLRequestBuilder
    private let urlRequestSender: URLRequestSender
    private let converter: URLRequestSenderErrorConverter
    private let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy

    public init(
        urlRequestBuilder: URLRequestBuilder,
        urlRequestSender: URLRequestSender,
        converter: URLRequestSenderErrorConverter,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) {
        self.urlRequestBuilder = urlRequestBuilder
        self.urlRequestSender = urlRequestSender
        self.converter = converter
        self.keyDecodingStrategy = keyDecodingStrategy
    }

    public func send<T: Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        urlRequestSender.send(urlRequest: urlRequestBuilder.build(from: request)) { [converter, keyDecodingStrategy] data, error in
            if let error = error {
                completion(.failure(converter.convert(urlSessionSenderError: error)))
            } else if let data = data {
                do {
                    let sanitizedData = data.isEmpty ? "{}".data(using: .utf8)! : data
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = keyDecodingStrategy
                    let object = try decoder.decode(T.self, from: sanitizedData)
                    completion(.success(object))
                } catch let error {
                    print("[ERROR] \(error)")
                }
            } else {
                fatalError("This should not happen")
            }
        }
    }

    public func download(fromURL url: URL, completion: @escaping (Result<Data, ApiError>) -> Void) {
        urlRequestSender.download(url: url) { [converter] data, error in
            if let error = error {
                completion(.failure(converter.convert(urlSessionSenderError: error)))
            } else if let data = data {
                completion(.success(data))
            } else {
                fatalError("This should not happen")
            }
        }
    }
}

