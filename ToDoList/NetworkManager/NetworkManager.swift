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
        let url = URL(string: "https://run.mocky.io/v3/4a517c25-3062-43ca-9152-b8a8be7a3188")!
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        
        networkService.makeRequestArray(request: request, completion: completion)
    }
    
}
