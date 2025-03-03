//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func getTask(completion: @escaping (Result<Task, NetworkError>) -> Void)
    var networkService: NetworkServiceProtocol! {get}
}

final class NetworkManager: NetworkManagerProtocol {
    var networkService: NetworkServiceProtocol!
    
    func getTask(completion: @escaping (Result<Task, NetworkError>) -> Void) {
        let url = URL(string: "https://run.mocky.io/v3/8213488e-9963-4290-9c43-ab6f2684ccd1")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        networkService.makeRequestArray(request: request, completion: completion)
    }
    
}
