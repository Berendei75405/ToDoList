//
//  Enums.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation

//Для состояния таблицы
enum TableState {
    case success, failure(NetworkError), initial
}

//MARK: - NetworkError
enum NetworkError: Error {
    case errorWithDescription(String)
    case error(Error)
}
