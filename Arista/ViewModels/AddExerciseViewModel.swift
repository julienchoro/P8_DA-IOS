//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addExercise() -> Bool {
        do {
            try ExerciseRepository(viewContext: viewContext).addExercice(category: category,
                                                                         duration: duration,
                                                                         intensity: intensity,
                                                                         startDate: Date)
            return true
        } catch {
            return false
        }
    }
}
