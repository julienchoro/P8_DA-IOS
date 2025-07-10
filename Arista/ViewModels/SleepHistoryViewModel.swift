//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [Sleep]()
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            let data = SleepRepository(viewContext: viewContext)
            sleepSessions = try data.getSleepSessions()
        } catch {
            print("Error when fetching sleep session data: \(error)")
        }
    }
}

//struct FakeSleepSession: Identifiable {
//    var id = UUID()
//    var startDate: Date = Date()
//    var duration: Int = 695
//    var quality: Int = (0...10).randomElement()!
//}
