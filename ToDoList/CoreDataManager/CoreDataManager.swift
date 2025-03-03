//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Novgorodcev on 10/01/2025.
//

import Foundation
import CoreData

//MARK: - CoreDataManagerProtocol
protocol CoreDataManagerProtocol: AnyObject {
    var persistentContainer: NSPersistentContainer { get set }
    func fetchTask(task: Task)
    func taskIsEmpty() -> Bool
    func saveChangesContext(contextIsView: Bool)
    func addTodos(newIndex: Int)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    //MARK: - context
    var mainContext = AppDelegate.persistentContainer.viewContext
    var backgroundContext = AppDelegate.persistentContainer.newBackgroundContext()
    
    //MARK: - persistentContainer
    var persistentContainer = AppDelegate.persistentContainer
    
    //MARK: - saveChangesContext
    func saveChangesContext(contextIsView: Bool) {
        let context = contextIsView ? mainContext : backgroundContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - fetchTask
    func fetchTask(task: Task) {
        //проверка нет ли записей
        let request = TaskModel.fetchRequest()
        guard let count = try? mainContext.count(for: request) else { return }
        
        if count == .zero {
            //создание задач
            let taskCoreData = TaskModel(context: self.mainContext)
            
            for item in task.todos {
                let todo = Todos(context: self.mainContext)
                todo.title = item.title
                todo.todo = item.todo
                todo.wasCreate = item.wasCreate
                todo.completed = item.completed
                todo.id = Int16(item.id)
                todo.userID = Int16(item.userID)
                
                //указываем связывание!
                taskCoreData.addToTodos(todo)
            }
            self.saveChangesContext(contextIsView: true)
        }
    }
    
    //MARK: - taskIsEmpty
    func taskIsEmpty() -> Bool {
        let request = Todos.fetchRequest()
        let todos = try? mainContext.fetch(request)
        
        return todos?.count == 0
    }
    
    //MARK: - func addTodos
    func addTodos(newIndex: Int) {
        let request = TaskModel.fetchRequest()
        guard let task = try? mainContext.fetch(request).first else { return }
        
        let todos = Todos(context: mainContext)
        todos.id = Int16(newIndex)
        todos.completed = false
        todos.title = ""
        todos.todo = ""
        todos.userID = Int16(newIndex)
        todos.wasCreate = Date()
        todos.taskModel = task
        task.addToTodos(todos)
        
        saveChangesContext(contextIsView: true)
    }
    
}
