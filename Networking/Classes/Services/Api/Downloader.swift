//
// Created by Karol Wieczorek on 08.02.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

extension ApiService {

    class Downloader {

        private let apiDataSource: ApiDataSource

        init(apiDataSource: ApiDataSource) {
            self.apiDataSource = apiDataSource
        }

        func download(fromURL url: URL, configuration: RequestConfiguration, completion: @escaping (Result<Data, ApiError>) -> Void) {
            download(fromURL: url, retries: configuration.numberOfRetries, completion: completion)
        }

        private func download(fromURL url: URL, retries: Int, completion: @escaping (Result<Data, ApiError>) -> Void) {
            apiDataSource.download(fromURL: url) { result in
                result.ifSuccess { data in
                    completion(.success(data))
                }.else { [weak self] error in
                    self?.handle(error, url: url, retries: retries, completion: completion)
                }
            }
        }

        private func handle(_ error: ApiError, url: URL, retries: Int, completion: @escaping (Result<Data, ApiError>) -> Void) {
            switch error {
                case .network:
                    handle(networkError: error, url: url, retries: retries, completion: completion)
                case .http(_), .cannotParseData, .cannotBuildRequest:
                    completion(.failure(error))
            }
        }

        private func handle(networkError error: ApiError, url: URL, retries: Int, completion: @escaping (Result<Data, ApiError>) -> Void) {
            if retries == 0 {
                completion(.failure(error))
            } else {
                download(fromURL: url, retries: retries - 1, completion: completion)
            }
        }
    }
}
