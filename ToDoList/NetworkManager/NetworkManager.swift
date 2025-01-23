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
        let url = URL(string: "https://run.mocky.io/v3/7d1167d0-3315-46c7-b258-8dad1dc581eb")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        networkService.makeRequestArray(request: request, completion: completion)
    }
    
}
