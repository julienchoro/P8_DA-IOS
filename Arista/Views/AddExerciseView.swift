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
                    TextField("Catégorie", text: $viewModel.category)
                    
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
                }.buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
