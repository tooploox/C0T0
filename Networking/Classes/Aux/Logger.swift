//
//  Logger.swift
//  Networking
//
//  Created by Paweł Chmiel on 11.09.2018.
//

import Foundation

final class Logger {
    private let loggingEnabled: Bool
    init(loggingEnabled: Bool) {
        self.loggingEnabled = loggingEnabled
    }
    
    func log(_ object: Any?) {
        guard loggingEnabled, let object = object else { return }
       
        if object is URLRequest {
            print("Request\n\(object)\n")
        } else if object is Data {
            guard let object = object as? Data, let jsonDictionary = try? JSONSerialization.jsonObject(with: object, options: .allowFragments),
                let data: Data = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted),
                let stringJson = String(data: data, encoding: .utf8)
                else {
                    return
            }
            print("Data\n\(stringJson)\n")
        } else if object is ApiError {
            print("Error\n\(object)")
        } else if object is URL {
            print("URL\n\(object)")
        }
    }
}

