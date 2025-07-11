//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

import CoreData

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [ExerciseData]()

    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }

    private func fetchExercises() {
        do {
            let repository = ExerciseRepository(viewContext: viewContext)
            exercises = try repository.getExerciseData()
        } catch {
            print("Error when fetching exercise data: \(error)")
        }
    }
    
    func reload() {
        fetchExercises()
    }
}
