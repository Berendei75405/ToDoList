//
//  Task.swift
//  ToDoList
//
//  Created by Novgorodcev on 24/12/2024.
//

import Foundation

// MARK: - Task
struct Task: Codable {
    var todos: [Todo]
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int
    var title: String
    var todo: String
    var completed: Bool
    let userID: Int
    let wasCreate: Date

    enum CodingKeys: String, CodingKey {
        case id, todo,
             completed, wasCreate,
             title
        case userID = "userId"
    }
}
