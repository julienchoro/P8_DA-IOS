//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }

    private func fetchUserData() {
        do {
            if let user = try UserRepository(viewContext: viewContext).getUser() {
                firstName = user.firstName ?? ""
                lastName = user.lastName ?? ""
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
