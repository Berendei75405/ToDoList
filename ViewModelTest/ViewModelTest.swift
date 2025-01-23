//
//  ViewModelTest.swift
//  ViewModelTest
//
//  Created by Novgorodcev on 22/01/2025.
//

import XCTest
@testable import ToDoList

final class ViewModelTests: XCTestCase {
    
    private var viewModel: TaskViewModel!
    private var mockNetworkManager: MockNetworkManager!
    private var mockCoreDataManager: CoreDataManagerProtocol!
    private var mockCoordinator: CoordinatorProtocol!

    //инициализация обьектов для тестирования
    override func setUpWithError() throws {
        viewModel = TaskViewModel()
        mockNetworkManager = MockNetworkManager()
        mockCoreDataManager = MockCoreDataManager()
        mockCoordinator = MockCoordinator()
        
        viewModel.networkManager = mockNetworkManager
        viewModel.coordinator = mockCoordinator
        viewModel.coreDataManager = mockCoreDataManager
    }
    
    //по окончанию тестов обнуляет обьекты
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil
        mockCoordinator = nil
        mockCoreDataManager = nil
    }

    func testGetTaskCoreData() throws {
        //загрузка данными
        let task = Task.init(todos: [.init(id: 1, title: "", todo: "", completed: true, userID: 1, dateString: "1")])
        let coreData = viewModel.coreDataManager as? MockCoreDataManager
        coreData?.taskToReturn = task
        
        //вызов метода
        viewModel.getTask()
        
        //сравнение
        XCTAssertEqual(task.todos.first?.id,
                       viewModel.task?.todos.first?.id)
    }
    
    func testGetTaskNetwork() throws {
        //загрузка данными
        let task = Task.init(todos: [.init(id: 1, title: "", todo: "", completed: true, userID: 1, dateString: "1")])
        let network = viewModel.networkManager as? MockNetworkManager
        network?.shoudReturnError = false
        network?.task = task
        
        let coreData = viewModel.coreDataManager as? MockCoreDataManager
        coreData?.shoudReturnError = true
        
        
        //вызов метода
        viewModel.getTask()
        
        //сравнение
        XCTAssertEqual(task.todos.first?.id,
                       viewModel.task?.todos.first?.id)
    }
    
    func testGetTaskError() throws {
        //выставление условий
        let coreData = viewModel.coreDataManager as? MockCoreDataManager
        coreData?.shoudReturnError = true
        let network = viewModel.networkManager as? MockNetworkManager
        network?.shoudReturnError = true
        
        //вызов метода
        viewModel.getTask()
        
        //сравнение
        XCTAssertNil(viewModel.task)
    }
    
    func testRemoveTodo() throws {
        //выставление условий
        let task = Task.init(
            todos: [.init(id: .zero,
                          title: "",
                          todo: "",
                          completed: true,
                          userID: .zero,
                          dateString: "")])
        let coreData = viewModel.coreDataManager as? MockCoreDataManager
        coreData?.taskToReturn = task
        viewModel.task = task
        
        //вызов метода
        viewModel.removeTodo(index: .zero)
        
        //сравнение
        XCTAssertEqual(coreData?.taskToReturn.todos.count, viewModel.task?.todos.count)
    }

}
