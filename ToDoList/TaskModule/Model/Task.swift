//
//  Task.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation

// MARK: - Task
struct Task: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int
    let title: String
    let todo: String
    let completed: Bool
    let userID: Int
    let dateString: String

    enum CodingKeys: String, CodingKey {
        case id, todo,
             completed, dateString,
             title
        case userID = "userId"
    }
}
