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
