//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class AddExerciseViewModel: ObservableObject {
    let catégories = ["Football", "Natation", "Running", "Marche", "Cyclisme", "Fitness", "Yoga", "Musculation"]
    @Published var category: String = "Running"
    @Published var startTime: Date = Date()
    @Published var duration: Int = 30
    @Published var intensity: Int = 5
    
    var isFormValid: Bool {
        !category.isEmpty &&
        duration > 0 &&
        startTime <= Date() &&
        intensity >= 0 && intensity <= 10
    }

    private var repository: ExerciseRepository

    init(repository: ExerciseRepository) {
        self.repository = repository
    }

    func addExercise() -> Bool {
        do {
            try repository.addExercise(category: category,
                                       duration: duration,
                                       intensity: intensity,
                                       startDate: startTime)
            return true
        } catch {
            print("Error when adding exercise data: \(error)")
            return false
        }
    }
}
