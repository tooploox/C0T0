//
// Created by Karolina Samorek on 21/12/2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public enum SecureStorageDataSourceSavingError: Error {
    case cannotSaveData
}

public protocol SecureStorageDataSource {
    func load() -> Any?
}
