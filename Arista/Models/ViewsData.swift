//
//  ViewData.swift
//  Arista
//
//  Created by Julien Choro on 11/07/25.
//

import Foundation

// MARK: - User Data
struct UserData {
    let firstName: String
    let lastName: String
}

// MARK: - Sleep Data
struct SleepData: Identifiable {
    let id = UUID()
    let duration: Int
    let quality: Int
    let startDate: Date
}

// MARK: - Exercise Data
struct ExerciseData: Identifiable {
    let id = UUID()
    let category: String
    let duration: Int     // en minutes
    let intensity: Int    // de 0 à 10
    let startDate: Date
}
