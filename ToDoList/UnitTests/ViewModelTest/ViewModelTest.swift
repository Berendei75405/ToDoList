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
    
    func testGetTaskNetwork() throws {
        //загрузка данными
        let network = viewModel.networkManager as? MockNetworkManager
        network?.shoudReturnError = false
        let task = Task(todos: [Todo(id: .zero, title: "", todo: "", completed: true, userID: .zero, wasCreate: Date())])
        network?.task = task
        
        //вызов метода
        viewModel.getTask()
        
        //сравнение
        XCTAssertEqual(task.todos.first?.id,
                       network?.task.todos.first?.id)
    }
    
    func testGetTaskError() throws {
        //выставление условий
        let error = NetworkError.errorWithDescription("Ошибка")
        let network = viewModel.networkManager as? MockNetworkManager
        network?.shoudReturnError = true
        
        //вызов метода
        viewModel.getTask()
        
        //сравнение
        XCTAssertEqual(error.localizedDescription, network?.error.localizedDescription)
    }
    
    func testRemoveTodo() throws {
        //выставление условий
        let task = Task(todos: [.init(id: .zero,
                          title: "",
                          todo: "",
                          completed: true,
                          userID: .zero,
                          wasCreate: Date())])
        let coreData = viewModel.coreDataManager as? MockCoreDataManager
        let indexPath = IndexPath(row: .zero,
                                  section: .zero)
        var oldCount =  Int(viewModel.fetchedResultsController?.fetchedObjects?.count ?? .zero)
        
        //вызов методов
        coreData?.fetchTask(task: task)
        viewModel.getTask()
        XCTAssertTrue(oldCount < Int(viewModel.fetchedResultsController?.fetchedObjects?.count ?? .zero))
        oldCount = Int(viewModel.fetchedResultsController?.fetchedObjects?.count ?? .zero)
        viewModel.removeTodo(at: indexPath)
        
        XCTAssertTrue(oldCount == Int(viewModel.fetchedResultsController?.fetchedObjects?.count ?? .zero))
    }

}
