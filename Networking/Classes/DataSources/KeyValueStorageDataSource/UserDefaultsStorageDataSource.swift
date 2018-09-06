//
// Created by Karolina Samorek on 21/12/2017.
// Copyright (c) 2017 Tooploox. All rights reserved.
//

import Foundation

public class UserDefaultsStorageDataSource: KeyValueStorageDataSource {

    public weak var delegate: KeyValueStorageDataSourceDelegate?

    private let userDefaults = UserDefaults.standard

    public init() {
    }
    
    public func save<T>(key: String, value: T) {
        userDefaults.set(value, forKey: key)
        delegate?.keyValueStorageDataSource(dataSource: self, didChangeValueForKey: key)
    }

    public func read<T>(key: String) -> T? {
        return userDefaults.value(forKey: key) as? T
    }
}
