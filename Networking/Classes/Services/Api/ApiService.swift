//
// Created by Karol Wieczorek on 05.02.2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

public protocol ApiService {
    func send<T: Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void)
    func send<T: Decodable>(request: ApiRequest, retries: Int, completion: @escaping (Result<T, ApiError>) -> Void)
    func download(fromURL url: URL, completion: @escaping(Result<Data, ApiError>) -> Void)
}
