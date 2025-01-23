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
    func fetchTask(task: Task)
    func removeTodo(index: Int)
    func getTask() -> Task?
    func editTodo(todo: Todo)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
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
        guard let count = try? mainContext.count(for: request) else { return }
        
        mainContext.perform {
            if count == .zero {
                //создание задач
                let taskCoreData = TaskModel(context: self.mainContext)
                
                for item in task.todos {
                    let todo = Todos(context: self.mainContext)
                    todo.title = item.title
                    todo.todo = item.todo
                    todo.dateString = item.dateString
                    todo.completed = item.completed
                    todo.id = Int16(item.id)
                    todo.userID = Int16(item.userID)
                    
                    //указываем связывание!
                    taskCoreData.addToTodo(todo)
                }
                self.saveChangesContext(contextIsView: true)
            }
        }
    }
    
    /// Метод позволяющий удалять задачи
    func removeTodo(index: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            guard let taskModels = try mainContext.fetch(fetchRequest).first else { return }
            guard let taskModel = taskModels as? TaskModel else { return }
            guard taskModel.todo != nil else { return }
            
            for taskModel in taskModel.todo! {
                guard let todos = taskModel as? Todos else { return }
                //удаление элемента
                if index == todos.id {
                    mainContext.delete(todos)
                }
                
                //изменение других индексов
                if index < todos.id {
                    todos.id -= 1
                }
                saveChangesContext(contextIsView: true)
            }
        } catch {
            print("Ошибка при пакетном удалении Todo: $error)")
        }
    }
    
    ///Получение задач
    func getTask() -> Task? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
        guard ((try? mainContext.count(for: fetchRequest)) != nil) else { return nil }
        
        do {
            let results = try mainContext.fetch(fetchRequest)
            guard let task = results.first as? TaskModel else { return nil }
            
            var taskModel = Task(todos: [])
            
            for todo in task.todo! {
                guard let todos = todo as? Todos else { return nil }
                
                let todoForModel = Todo(id: Int(todos.id),
                                        title: todos.title ?? "",
                                        todo: todos.todo ?? "",
                                        completed: todos.completed,
                                        userID: Int(todos.userID),
                                        dateString: todos.dateString ?? "")
        
                taskModel.todos.append(todoForModel)
            }
            
            taskModel.todos = taskModel.todos.sorted { $0.id < $1.id }
    
            return taskModel
        } catch {
            print("Ошибка при выполнении запроса: $error)")
        }
        
        return nil
    }
    
    //MARK: - editTodo
    func editTodo(todo: Todo) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        
        do {
            guard let taskModels = try mainContext.fetch(fetchRequest).first else { return }
            
            //поиск по индексу и изменение данных
            print(todo.id)
            if let taskModel = taskModels as? TaskModel {
                for taskModel in taskModel.todo! {
                    if let todos = taskModel as? Todos {
                        if todo.id == todos.id {
                            
                            todos.title = todo.title
                            todos.completed = todo.completed
                            todos.dateString = todo.dateString
                            todos.todo = todo.todo
                            
                            saveChangesContext(contextIsView: true)
                            return
                        }
                    }
                }
                //создание Todos, если ее нет в списке
                let todos = Todos(context: mainContext)
                todos.completed = todo.completed
                todos.dateString = todo.dateString
                todos.title = todo.title
                todos.id = Int16(todo.id)
                todos.todo = todo.todo
                todos.userID = Int16(todo.userID)
                
                taskModel.addToTodo(todos)
                saveChangesContext(contextIsView: true)
            }
        } catch {
            print("Ошибка при пакетном удалении Todo: $error)")
        }
    }
    
}
