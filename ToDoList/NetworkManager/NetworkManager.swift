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
        let url = URL(string: "https://run.mocky.io/v3/38bfd492-e85f-4f5f-beb8-592bfdf56ab1")!
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        
        networkService.makeRequestArray(request: request, completion: completion)
    }
    
}
