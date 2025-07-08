//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by Julien Choro on 08/07/25.
//

import XCTest
import CoreData

@testable import Arista

final class UserRepositoryTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var repository: UserRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        repository = UserRepository(viewContext: context)
        emptyUserEntities(context: context)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
        repository = nil
    }

    func test_WhenNoUserInDatabse_getUser_ReturnNoUser() throws {
        let user = try repository.getUser()
        XCTAssert(user == nil)
    }
    
    func test_WhenOneUserInDatabase_getUser_ReturnOneUser() throws {
        let testUser = User(context: context)
        testUser.firstName = "Ju"
        testUser.lastName = "Cho"
        try context.save()
        
        let user = try repository.getUser()
        
        XCTAssert(user != nil)
        XCTAssert(user?.firstName == "Ju")
        XCTAssert(user?.lastName == "Cho")
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
