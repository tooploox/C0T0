//
// Created by Karolina Samorek on 06/02/2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

public protocol UrlRequestSenderErrorConverter {
    func convert(urlSessionSenderError: UrlRequestSenderError) -> ApiError
}
