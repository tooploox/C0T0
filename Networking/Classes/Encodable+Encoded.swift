//
// Created by Karolina Samorek on 10/04/2018.
// Copyright (c) 2018 Tooploox. All rights reserved.
//

import Foundation

extension Encodable {

    var encoded: Data? {
        return try? JSONEncoder().encode(self)
    }

    var dictionary: [String: Any] {
        if
            let data = encoded,
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let dictionary = jsonObject as? [String: Any] {
                return dictionary
        } else {
            return [:]
        }
    }
}
