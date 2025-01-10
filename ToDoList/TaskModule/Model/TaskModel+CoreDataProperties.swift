//
//  TaskModel+CoreDataProperties.swift
//  ToDoList
//
//  Created by Novgorodcev on 10/01/2025.
//
//

import Foundation
import CoreData


extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var todo: NSSet?

}

// MARK: Generated accessors for todo
extension TaskModel {

    @objc(addTodoObject:)
    @NSManaged public func addToTodo(_ value: Todos)

    @objc(removeTodoObject:)
    @NSManaged public func removeFromTodo(_ value: Todos)

    @objc(addTodo:)
    @NSManaged public func addToTodo(_ values: NSSet)

    @objc(removeTodo:)
    @NSManaged public func removeFromTodo(_ values: NSSet)

}

extension TaskModel : Identifiable {

}
