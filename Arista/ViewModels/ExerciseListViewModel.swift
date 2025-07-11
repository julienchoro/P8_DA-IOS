//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [ExerciseData]()

    var repository: ExerciseRepository

    init(repository: ExerciseRepository) {
        self.repository = repository
        fetchExercises()
    }

    private func fetchExercises() {
        do {
            exercises = try repository.getExerciseData()
        } catch {
            print("Error when fetching exercise data: \(error)")
        }
    }
    
    func reload() {
        fetchExercises()
    }
}
