//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [SleepData]()
    
    private var repository: SleepRepository
    
    init(repository: SleepRepository) {
        self.repository = repository
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            sleepSessions = try repository.getSleepData()
        } catch {
            print("Error when fetching sleep session data: \(error)")
            sleepSessions = []
        }
    }
}
