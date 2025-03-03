//
//  Todos+CoreDataProperties.swift
//  ToDoList
//
//  Created by Novgorodcev on 20/02/2025.
//
//

import Foundation
import CoreData


extension Todos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todos> {
        return NSFetchRequest<Todos>(entityName: "Todos")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var wasCreate: Date?
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var userID: Int16
    @NSManaged public var taskModel: TaskModel?

}

extension Todos : Identifiable {

}
