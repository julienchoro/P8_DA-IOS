//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Arista")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("CoreData Error: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if inMemory == false {
            try! DefaultData(viewContext: container.viewContext).apply()
        }
    }
}

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        try! DefaultData(viewContext: viewContext).apply()

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Preview data setup error: \(error)")
        }
        return result
    }()
}
