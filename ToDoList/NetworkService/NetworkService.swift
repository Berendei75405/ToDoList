//
//  NetworkService.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation


final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    //MARK: - makeRequestArray
    func makeRequestArray<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        //если есть кеш на запрос, то вернуть его, если нет то отправить запрос и записать кеш
        if let cashedResponse = URLCache.shared.cachedResponse(for: request) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedData = try? decoder.decode(T.self, from: cashedResponse.data) {
                
                completion(.success(decodedData))
                return
            }
        }
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //обработанная ошибка
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 300..<400:
                    return completion(.failure(.errorWithDescription("Запрошенный ресурс перемещен в другое место.")))
                case 400..<500:
                    return completion(.failure(.errorWithDescription("Запрос содержит неверный синтаксис или не может быть выполнен.")))
                case 500..<600:
                    return completion(.failure(.errorWithDescription("Сервер не смог выполнить запрос.")))
                default:
                    break
                }
            }
            
            //необработанная ошибка
            if let error = error {
                completion(.failure(.errorWithDescription("Возникла непредвиденная ошибка или отсутствует соединение с интернетом")))
                print(error)
            }
            
            //обработка успешного ответа
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    //decoder.dateDecodingStrategy = .iso8601
                    let decodedData = try decoder.decode(T.self, from: data)
                    
                    //кеширование ответа
                    if response != nil {
                        let cashedResponse = CachedURLResponse(response: response!, data: data)
                        URLCache.shared.storeCachedResponse(cashedResponse, for: request)
                    }
                    
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.errorWithDescription("\(error)")))
                }
            }
        }
        
        //отправляем запрос
        task.resume()
        
    }
    
}
