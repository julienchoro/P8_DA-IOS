//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by Julien Choro on 09/07/25.
//

import XCTest
import CoreData
import Combine

@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var viewModel: AddExerciseViewModel!
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        
        emptyEntities(context: context)
        
        let user = User(context: context)
        user.firstName = "Ju"
        user.lastName = "Cho"
        try! context.save()
        
        viewModel = AddExerciseViewModel(context: context)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
        viewModel = nil
        cancellables.removeAll()
    }

    func test_InitialState_HasDefaultValues() {
        XCTAssertEqual(viewModel.category, "Running")
        XCTAssertEqual(viewModel.duration, 30)
        XCTAssertEqual(viewModel.intensity, 5)
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func test_WhenCategoryIsEmpty_IsFormValid_ReturnsFalse() {
        viewModel.category = ""
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func test_WhenDurationIsZero_IsFormValid_ReturnsFalse() {
        viewModel.duration = 0
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func test_WhenStartTimeIsInFuture_IsFormValid_ReturnsFalse() {
        viewModel.startTime = Date(timeIntervalSinceNow: 3600)
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func test_WhenAllFieldsAreValid_IsFormValid_ReturnsTrue() {
        viewModel.category = "Football"
        viewModel.duration = 45
        viewModel.intensity = 7
        viewModel.startTime = Date(timeIntervalSinceNow: -3600) // 1 heure dans le passé
        
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func test_WhenAddingValidExercise_AddExercise_ReturnsTrue() {
        // Configurer des données valides
        viewModel.category = "Yoga"
        viewModel.duration = 60
        viewModel.intensity = 3
        viewModel.startTime = Date()
        
        // Ajouter l'exercice
        let result = viewModel.addExercise()
        
        XCTAssertTrue(result)
        
        // Vérifier que l'exercice a bien été ajouté
        let repository = ExerciseRepository(viewContext: context)
        let exercises = try! repository.getExercises()
        
        XCTAssertEqual(exercises.count, 1)
        XCTAssertEqual(exercises.first?.category, "Yoga")
        XCTAssertEqual(exercises.first?.duration, 60)
        XCTAssertEqual(exercises.first?.intensity, 3)
    }
    
    func test_CategoryChanges_ArePublishedCorrectly() {
        var receivedValues: [String] = []
        let expectation = XCTestExpectation(description: "category changes")
        
        viewModel.$category
            .sink { category in
                receivedValues.append(category)
                if receivedValues.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.category = "Football"
        viewModel.category = "Yoga"
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(receivedValues, ["Running", "Football", "Yoga"])
    }
    
    
    // MARK: - Utility methods
    private func emptyEntities(context: NSManagedObjectContext) {
        let exerciseRequest = Exercise.fetchRequest()
        let exercises = try! context.fetch(exerciseRequest)
        for exercise in exercises {
            context.delete(exercise)
        }
        
        let userRequest = User.fetchRequest()
        let users = try! context.fetch(userRequest)
        for user in users {
            context.delete(user)
        }
        
        try! context.save()
    }

}
