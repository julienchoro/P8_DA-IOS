//
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by Julien Choro on 08/07/25.
//

import XCTest
import CoreData

@testable import Arista

final class SleepRepositoryTests: XCTestCase {
    
    var persistenceController : PersistenceController!
    var sleepRepository : SleepRepository!
    var context : NSManagedObjectContext!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        sleepRepository = SleepRepository(viewContext: context)
        emptyEntities(context: context)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
        context = nil
        sleepRepository = nil
    }
    
    func test_WhenNoSleepSessionInDatabase_getSleepSessions_ReturnEmptyList() {
        let sleepSessions = try! sleepRepository.getSleepData()
        XCTAssert(sleepSessions.count == 0)
    }
    
    func test_WhenOneSleepSessionInDatabase_getSleepSessions_ReturnListContainingTheSleepSession() {
        addSleepSession(context: context, duration: 120, quality: 80, startDate: Date(), userFirstName: "Ju", userLastName: "Cho")
        let sleepSessions = try! sleepRepository.getSleepData()
        XCTAssert(sleepSessions.count == 1)
    }
    
    func test_WhenMultipleSleepSessionInDatabase_getSleepSessions_ReturnAListContainingTheSleepSessionsInTheRightOrder() throws {
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleepSession(context: context, duration: 420, quality: 5, startDate: date1, userFirstName: "Ju", userLastName: "Cho")
        addSleepSession(context: context, duration: 520, quality: 6, startDate: date2, userFirstName: "Ju", userLastName: "Cho")
        addSleepSession(context: context, duration: 320, quality: 3, startDate: date3, userFirstName: "Ju", userLastName: "Cho")
        
        let sleepSessions = try! sleepRepository.getSleepData()
        XCTAssert(sleepSessions.count == 3)
        XCTAssert(sleepSessions[0].startDate == date1)
        XCTAssert(sleepSessions[1].startDate == date2)
        XCTAssert(sleepSessions[2].startDate == date3)
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
