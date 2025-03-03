//
//  TaskModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Novgorodcev on 20/02/2025.
//
//

import Foundation
import CoreData


extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension TaskModel {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todos)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todos)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension TaskModel : Identifiable {

}
