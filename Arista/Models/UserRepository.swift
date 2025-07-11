//
//  UserRepository.swift
//  Arista
//
//  Created by Julien Choro on 05/07/25.
//

import Foundation
import CoreData

struct UserRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getUserCoreData() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try viewContext.fetch(request).first
    }
    
    func getUserData() throws -> UserData? {
        guard let user = try getUserCoreData() else {
            return nil
        }
        
        return UserData(firstName: user.firstName ?? "",
                        lastName: user.lastName ?? "")
        
    }
    
}
