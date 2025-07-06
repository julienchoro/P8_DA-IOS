//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    let catégories = ["Football", "Natation", "Running", "Marche", "Cyclisme", "Fitness", "Yoga", "Musculation"]
    @Published var category: String = "Running"
    @Published var startTime: Date = Date()
    @Published var duration: Int = 30
    @Published var intensity: Int = 5
    
    var isFormValid: Bool {
        !category.isEmpty &&
        duration > 0 &&
        startTime <= Date()
    }

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addExercise() -> Bool {
        do {
            try ExerciseRepository(viewContext: viewContext).addExercice(category: category,
                                                                         duration: duration,
                                                                         intensity: intensity,
                                                                         startDate: startTime)
            return true
        } catch {
            print("Erreur lors de l'ajout")
            return false
        }
    }
}
