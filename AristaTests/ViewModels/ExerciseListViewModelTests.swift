//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by Julien Choro on 08/07/25.
//

import XCTest

import CoreData
import Combine

@testable import Arista

final class ExerciseListViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var repository: ExerciseRepository!

    var viewModel: ExerciseListViewModel!

    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        repository = ExerciseRepository(viewContext: context)
        
        viewModel = ExerciseListViewModel(context: context)
        
        emptyEntities(context: context)
    }
    
    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
        repository = nil
        
        viewModel = nil
        
        cancellables.removeAll()
    }
    
    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingOneExerciseInDatabase_FEtchExercise_ReturnAListContainingTheExercise() {
        let date = Date()
        addExercice(context: context,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date,
                    userFirstName: "Ericw",
                    userLastName: "Marcus")
        
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.reload()

        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty == false)
                XCTAssert(exercises.first?.category == "Football")
                XCTAssert(exercises.first?.duration == 10)
                XCTAssert(exercises.first?.intensity == 5)
                XCTAssert(exercises.first?.startDate == date)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addExercice(context: context,
                    category: "Football",
                    duration: 10,
                    intensity: 5,
                    startDate: date1,
                    userFirstName: "Ericn",
                    userLastName: "Marcusi")
        addExercice(context: context,
                    category: "Running",
                    duration: 120,
                    intensity: 1,
                    startDate: date3,
                    userFirstName: "Ericb",
                    userLastName: "Marceau")
        addExercice(context: context,
                    category: "Fitness",
                    duration: 30,
                    intensity: 5,
                    startDate: date2,
                    userFirstName: "Frédericp",
                    userLastName: "Marcus")

        viewModel.reload()

        let expectation = XCTestExpectation(description: "fetch empty list of exercise")
        
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.count == 3)
                XCTAssert(exercises[0].category == "Football")
                XCTAssert(exercises[1].category == "Fitness")
                XCTAssert(exercises[2].category == "Running")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenReloadingDataFromDatabase_reload_ListIsTheSameOrUpdated() {
        XCTAssert(viewModel.exercises.isEmpty)
        
        viewModel.reload()
        
        XCTAssert(viewModel.exercises.isEmpty)
        
        let date = Date()
        
        let user = User(context: persistenceController.container.viewContext)
        user.firstName = "Ju"
        user.lastName = "Cho"
        try! persistenceController.container.viewContext.save()
        
        try! repository.addExercice(category: "Running", duration: 45, intensity: 3, startDate: date)
        
        viewModel.reload()
        
        XCTAssert(viewModel.exercises.count == 1)
        XCTAssert(viewModel.exercises.first?.category == "Running")
    }
    
    // MARK: - Utility methods

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for exercice in objects {
            context.delete(exercice)
        }
        
        try! context.save()
    }
    
    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        try! context.save()
    }
}
