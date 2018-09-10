//
// Created by Karol Wieczorek on 08.02.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

extension StandardApiService {

    class Sender {

        private let apiDataSource: ApiDataSource
        private let requestDecorator: RequestDecorator

        init(apiDataSource: ApiDataSource, requestDecorator: @escaping RequestDecorator) {
            self.apiDataSource = apiDataSource
            self.requestDecorator = requestDecorator
        }

        func send<T: Decodable>(request: ApiRequest, configuration: RequestConfiguration, completion: @escaping (Result<T, ApiError>) -> Void) {
            let decoratedRequest = requestDecorator(request)
            send(decoratedRequest: decoratedRequest, retries: configuration.numberOfRetries, completion: completion)
        }

        private func send<T: Decodable>(decoratedRequest: ApiRequest, retries: Int, completion: @escaping (Result<T, ApiError>) -> Void) {
            apiDataSource.send(request: decoratedRequest) { (result: Result<T, ApiError>) in
                result.ifSuccess {
                    completion(.success($0))
                }.else { [weak self] error in
                    self?.handle(error, request: decoratedRequest, retries: retries, completion: completion)
                }
            }
        }

        private func handle<T: Decodable>(_ error: ApiError, request: ApiRequest, retries: Int, completion: @escaping (Result<T, ApiError>) -> Void) {
            switch error {
                case .network:
                    handle(networkError: error, request: request, retries: retries, completion: completion)
                case .http(_), .cannotParseData:
                    completion(.failure(error))
            }
        }

        private func handle<T: Decodable>(networkError error: ApiError, request: ApiRequest, retries: Int, completion: @escaping (Result<T, ApiError>) -> Void) {
            if retries == 0 {
                completion(.failure(error))
            } else {
                send(
                    decoratedRequest: request,
                    retries: retries - 1,
                    completion: completion
                )
            }
        }
    }
}
