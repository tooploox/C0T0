//
// Created by Karol Wieczorek on 11.12.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

protocol ApiDataSource {
    func send<T:Decodable>(request: ApiRequest, completion: @escaping (Result<T, ApiError>) -> Void)
    func download(fromURL url: URL, completion: @escaping(Result<Data, ApiError>) -> Void)
}
