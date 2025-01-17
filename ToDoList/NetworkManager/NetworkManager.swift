//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation

final class NetworkManager {
    private var networkService = NetworkService.shared
    static let shared = NetworkManager()
    
    private init() {}
    
    func getTask(completion: @escaping (Result<Task, NetworkError>) -> Void) {
        let url = URL(string: "https://run.mocky.io/v3/56938c80-4956-482d-979b-7261619004ca")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        networkService.makeRequestArray(request: request, completion: completion)
    }
    
}
