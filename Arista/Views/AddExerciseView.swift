//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("Catégorie",
                           selection: $viewModel.category) {
                        ForEach(viewModel.catégories,
                                id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    
                    DatePicker("Heure de démarrage",
                               selection: $viewModel.startTime,
                               displayedComponents: [.date, .hourAndMinute])
                    
                    Stepper("Durée: \(viewModel.duration) minutes",
                            value: $viewModel.duration,
                            in: 0...300)
                    
                    Stepper("Intensité: \(viewModel.intensity)/10",
                            value: $viewModel.intensity,
                            in: 0...10)
                }.formStyle(.grouped)
                
                Spacer()
                
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isFormValid)
            }
            .navigationTitle("Nouvel Exercice ...")
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
