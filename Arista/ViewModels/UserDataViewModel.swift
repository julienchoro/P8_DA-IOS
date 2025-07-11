//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
        fetchUserData()
    }

    private func fetchUserData() {
        do {
            if let user = try repository.getUserData() {
                firstName = user.firstName
                lastName = user.lastName
            } else {
                print("No user found in database, using default values")
                firstName = "default"
                lastName = "values"
            }

        } catch {
            print("Error when fetching user data: \(error)")
        }
    }
}
