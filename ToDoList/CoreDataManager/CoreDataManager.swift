//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Novgorodcev on 10/01/2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    //context
    private lazy var mainContext = persistentContainer.viewContext
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        //при конфликте отдавать предпочтения новым данным
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return context
    }()
    
    //container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                print(error)
            }
        })
        return container
    }()
    
    //MARK: - saveChangesContext
    private func saveChangesContext(contextIsView: Bool) {
        let context = contextIsView ? mainContext : backgroundContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    ///метод используется для записи в coreData задач с интернета
    func fetchTask(task: Task) {
        //проверка нет ли записей
        let request = TaskModel.fetchRequest()
        guard let count = try? backgroundContext.count(for: request) else { return }
        backgroundContext.perform {
            if count == .zero {
                //создание задач
                let taskCoreData = TaskModel(context: self.backgroundContext)
                for item in task.todos {
                    let todo = Todos(context: self.mainContext)
                    todo.title = item.title
                    todo.todo = item.todo
                    todo.dateString = item.dateString
                    todo.completed = item.completed
                    todo.id = Int16(item.id)
                    todo.userID = Int16(item.userID)
                    taskCoreData.todo?.adding(todo)
                }
                self.saveChangesContext(contextIsView: false)
            }
        }
    }
    
    /// Метод позволяющий удалять задачи
    func removeTodo(index: Int) {
        let deleteFetch: NSFetchRequest<NSFetchRequestResult> = Todos.fetchRequest()
        deleteFetch.predicate = NSPredicate(format: "id == %d", index)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        batchDeleteRequest.resultType = .resultTypeStatusOnly

        do {
            let result = try backgroundContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
            let deletedObjectsCount = result.result as! Int
            print("\(deletedObjectsCount) объектов Todo успешно удалено.")
        } catch {
            print("Ошибка при пакетном удалении Todo: $error)")
        }
    }
    
}
