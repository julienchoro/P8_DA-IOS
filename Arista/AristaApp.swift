//
//  AristaApp.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

@main
struct AristaApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                UserDataView(viewModel: UserDataViewModel(
                    repository: UserRepository(
                        viewContext: persistenceController.container.viewContext
                        )
                    )
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Utilisateur", systemImage: "person")
                }
                
                ExerciseListView(viewModel: ExerciseListViewModel(
                        repository: ExerciseRepository(
                                viewContext: persistenceController.container.viewContext
                        )
                    )
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Exercices", systemImage: "flame")
                }
            
                SleepHistoryView(viewModel: SleepHistoryViewModel(
                    repository: SleepRepository(
                        viewContext: persistenceController.container.viewContext
                        )
                    )
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Sommeil", systemImage: "moon")
                }

            }
        }
    }
}
