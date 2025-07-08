//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Julien Choro on 08/07/25.
//

import XCTest
import CoreData
import Combine

@testable import Arista

final class UserDataViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var repository: UserRepository!
    
    var viewModel: UserDataViewModel!
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        repository = UserRepository(viewContext: context)
        
        emptyUserEntities(context: context)
        
        viewModel = UserDataViewModel(context: context)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
        repository = nil
        
        viewModel = nil
        
        cancellables.removeAll()
    }
    
    func test_WhenUserExistInDatabase_FetchUserData_LoadsUserData() {
        viewModel = UserDataViewModel(context: context)
        
        let firstNameExpectation = expectation(description: "Fetch user first name")
        let lastNameExpectation = expectation(description: "Fetch user last name")
        
        viewModel.$firstName
            .sink { firstName in
                XCTAssertEqual(firstName, "Julien")
                firstNameExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$lastName
            .sink { lastName in
                XCTAssertEqual(lastName, "Choro")
                lastNameExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [firstNameExpectation, lastNameExpectation], timeout: 10)
    }

    // MARK: - Utility methods
    private func emptyUserEntities(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for user in objects {
            context.delete(user)
        }
        
        try! context.save()
    }
}
