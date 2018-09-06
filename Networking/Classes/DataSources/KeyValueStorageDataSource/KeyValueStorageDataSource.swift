//
// Created by Karolina Samorek on 21/12/2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public protocol KeyValueStorageDataSourceDelegate: class {
    func keyValueStorageDataSource(dataSource: KeyValueStorageDataSource, didChangeValueForKey key: String)
}

public protocol KeyValueStorageDataSource: class {
    var delegate: KeyValueStorageDataSourceDelegate? { get set }

    func save<T>(key: String, value: T)
    func read<T>(key: String) -> T?
}
