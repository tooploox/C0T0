//
//  ViewController.swift
//  NetworkingExample
//
//  Created by Karol on 06.09.2018.
//  Copyright © 2018 Tooploox. All rights reserved.
//

import UIKit
import Networking

struct Model: Codable {
    let id: Int
    let name: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    
        requestRepos(for: "pchmiel")
    }
    
    private func requestRepos(for user: String) {
        let sessionConfiguration = SessionConfiguration(host: "https://api.github.com")
        let apiService = ApiService(configuration: sessionConfiguration)
        let apiRequest = ApiRequest(endpoint: "/users/\(user)/repos", method: .GET)
        
        apiService.send(request: apiRequest) { (result: Result<[Model], ApiError>) in
            print(result)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

