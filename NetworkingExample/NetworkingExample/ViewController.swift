//
//  ViewController.swift
//  NetworkingExample
//
//  Created by Karol on 06.09.2018.
//  Copyright © 2018 Tooploox. All rights reserved.
//

import UIKit
import Networking

final class ViewController: UIViewController {

    private var repositories: [Repository]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let tableView = UITableView()
    
    //Session configuration
    private let sessionConfiguration = SessionConfiguration(host: "https://api.github.com")
    private lazy var apiService = ApiService(configuration: sessionConfiguration)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    
        setupTableView()
        
        requestRepos(for: "google")
    }
    
    private func requestRepos(for organization: String) {
        
        let apiRequest = ApiRequest(endpoint: "/orgs/\(organization)/repos", method: .GET)
        
        apiService.send(request: apiRequest) { [weak self] (result: Result<[Repository], ApiError>) in
            result.ifSuccess { repositories in
                self?.repositories = repositories
            }.else(closure: { error in
                DispatchQueue.main.async {
                    self?.showAlertWith(error)
                }
            })
        }
    }
}
 
extension ViewController {
   private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "repositoryCell")
        tableView.delegate = self
        tableView.dataSource = self
    
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func showAlertWith(_ error: ApiError) {
        let alertViewController = UIAlertController(title: "Erorr", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okButton)
        
        present(alertViewController, animated: true, completion: nil)
    }
 }

 extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell"),
            let repositoryName = repositories?[indexPath.row].name else {
                return UITableViewCell()
        }
    
        cell.textLabel?.text = repositoryName
        
        return cell
    }
 }
