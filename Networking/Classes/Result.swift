//
// Created by Karol Wieczorek on 23.11.2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public enum Result<V, E: Error> {
    case success(V)
    case failure(E)

    @discardableResult func ifSuccess<R>(closure: (V) -> R) -> ElseResult<E, R> {
        switch self {
            case .success(let value):
                return .success(closure(value))
            case .failure(let error):
                return .failure(error)
        }
    }

    var value: V? {
        if case .success(let value) = self {
            return value
        } else {
            return nil
        }
    }

    var error: E? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }

    var isSuccess: Bool {
        return value != nil
    }

    var isFailure: Bool {
        return error != nil
    }
}

enum ElseResult<E: Error, R> {
    case success(R)
    case failure(E)

    func `elseReturn`(closure: (E) -> R) -> R {
        switch self {
            case .success(let value):
                return value
            case .failure(let error):
                return closure(error)
        }
    }

    func `else`(closure: (E) -> Void) {
        if case .failure(let error) = self {
            closure(error)
        }
    }
}
