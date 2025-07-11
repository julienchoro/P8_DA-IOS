//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [SleepData]()
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            let repository = SleepRepository(viewContext: viewContext)
            sleepSessions = try repository.getSleepData()
        } catch {
            print("Error when fetching sleep session data: \(error)")
            sleepSessions = []
        }
    }
}
