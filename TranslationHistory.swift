//
//  TranslationHistory.swift
//  TranslateMe
//
//  Created by Christopher Petit on 3/17/25.
//
import SwiftUI

struct TranslationHistory: View {
    @Binding var translationHistory: [Translation]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(translationHistory) { translation in
                        VStack(alignment: .leading) {
                            Text("🔤 \(translation.original)")
                                .fontWeight(.bold)
                            Text("🌍 \(translation.translated)")
                                .foregroundColor(.gray)
                        }
                    }
                }

                Button(action: clearHistory) {
                    Text("Clear All Transactions")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Translation History")
        }
    }

    func clearHistory() {
        FirebaseService.shared.clearHistory { success in
            if success {
                translationHistory.removeAll()
            }
        }
    }
}
