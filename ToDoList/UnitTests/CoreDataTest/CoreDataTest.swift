//
//  CoreDataTest.swift
//  CoreDataTest
//
//  Created by Novgorodcev on 22/01/2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class CoreDataTests: XCTestCase {
    private var coreData: CoreDataManager!
  
    //инициализация обьектов для тестирования
    override func setUpWithError() throws {
        //данные будут храниться не на диске, а на оперативной памяти
        coreData = CoreDataManager()
        
    }
    
    //по окончанию тестов обнуляет обьекты
    override func tearDownWithError() throws {
        coreData = nil
    }

    func testAddTodosAndRemove() throws {
        //загрузка данными
        let todo = Todo(
            id: 22,
            title: "",
            todo: "",
            completed: true,
            userID: 1,
            dateString: "")
        
        guard let taskCount = coreData.getTask()?.todos.count else { return }
        
        //вызов метода
        coreData.editTodo(todo: todo)
        
        //проверка условий
        guard let taskCountNew = coreData.getTask()?.todos.count else { return }
        XCTAssertTrue(taskCount < taskCountNew)
        coreData.removeTodo(index: todo.id)
    }
    
    func testFetchTask() {
        //загрузка данными
        let task = coreData.getTask()
        let taskNew = Task.init(todos: [.init(id: 1,
                                              title: "",
                                              todo: "",
                                              completed: true,
                                              userID: 1,
                                              dateString: "")])
        if task == nil {
            //вызов метода
            coreData.fetchTask(task: taskNew)
        }
        XCTAssertTrue(coreData.getTask() != nil)
    }

   

}

