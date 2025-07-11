//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Julien Choro on 05/07/25.
//

import Foundation
import CoreData

struct ExerciseRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getExercisesCoreData() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Exercise>(\.startDate, order: .reverse))]
        return try viewContext.fetch(request)
    }
    
    func getExerciseData() throws -> [ExerciseData] {
        let exercises = try getExercisesCoreData()
        
        var exerciseData: [ExerciseData] = []
        
        for exercise in exercises {
            exerciseData.append(ExerciseData(category: exercise.category ?? "",
                                             duration: Int(exercise.duration),
                                             intensity: Int(exercise.intensity),
                                             startDate: exercise.startDate ?? Date()))
        }
        
        return exerciseData
    }
    
    func addExercise(category: String, duration: Int, intensity: Int, startDate: Date) throws {
        let newExercise = Exercise(context: viewContext)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        
        let user = try UserRepository(viewContext: viewContext).getUserData()
        newExercise.user?.firstName = user?.firstName
        newExercise.user?.lastName = user?.lastName
        
        try viewContext.save()
    }
}
