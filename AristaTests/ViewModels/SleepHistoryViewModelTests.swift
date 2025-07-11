//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Julien Choro on 08/07/25.
//

import XCTest
import CoreData
import Combine

@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    var repository: SleepRepository!
    
    var viewModel: SleepHistoryViewModel!
    
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        repository = SleepRepository(viewContext: context)
        
        emptyEntities(context: context)
        
        viewModel = SleepHistoryViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
        repository = nil
        
        viewModel = nil
        
        cancellables.removeAll()
    }
    
    func test_When_No_SleepSessionInDatabase_FetchSleepSessions_ReturnEmptyList() {
        let expectation = XCTestExpectation(description: "fetch empty list of sleep session")
        
        viewModel.$sleepSessions
            .sink { sleepSessions in
                XCTAssert(sleepSessions.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenOneSleepSessionInDatabase_FetchSleepSessions_ReturnListWithOneSleepSession() {
        let expectation = XCTestExpectation(description: "fetch list with one sleep session")
        
        let date = Date()
        addSleepSession(context: context, duration: 420, quality: 8, startDate: date, userFirstName: "Ju", userLastName: "Cho")
        
        viewModel = SleepHistoryViewModel(repository: repository)
        
        viewModel.$sleepSessions
            .sink { sleepSessions in
                XCTAssert(sleepSessions.count == 1)
                XCTAssert(sleepSessions.first?.duration == 420)
                XCTAssert(sleepSessions.first?.quality == 8)
                XCTAssert(sleepSessions.first?.startDate == date)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 10)
    }
    
    func test_WhenMultipleSleepSessionInDatabase_FetchSleepSessions_ReturnListInCorrectOrder() {
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*48)*2)
        
        addSleepSession(context: context,
                        duration: 420,
                        quality: 8,
                        startDate: date1,
                        userFirstName: "Ju",
                        userLastName: "Cho")
        addSleepSession(context: context,
                        duration: 420,
                        quality: 8,
                        startDate: date2,
                        userFirstName: "Ju",
                        userLastName: "Cho")
        addSleepSession(context: context,
                        duration: 420,
                        quality: 8,
                        startDate: date3,
                        userFirstName: "Ju",
                        userLastName: "Cho")
        
        viewModel = SleepHistoryViewModel(repository: repository)
        
        let expectation = XCTestExpectation(description: "fetch list with one sleep session")
                
        viewModel = SleepHistoryViewModel(repository: repository)
        
        viewModel.$sleepSessions
            .sink { sleepSessions in
                XCTAssert(sleepSessions.count == 3)
                XCTAssert(sleepSessions[0].startDate == date1)
                XCTAssert(sleepSessions[1].startDate == date2)
                XCTAssert(sleepSessions[2].startDate == date3)

                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 10)
    }

    
    // MARK: - Utility methods
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for sleep in objects {
            context.delete(sleep)
        }
        
        try! context.save()
    }
    
    private func addSleepSession(context: NSManagedObjectContext, duration: Int, quality: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let newSleepSession = Sleep(context: context)
        newSleepSession.duration = Int64(duration)
        newSleepSession.quality = Int64(quality)
        newSleepSession.startDate = startDate
        newSleepSession.user?.firstName = userFirstName
        newSleepSession.user?.lastName = userLastName
        try! context.save()
    }
}
