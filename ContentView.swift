//
//  ContentView.swift
//  TranslateMe
//
//  Created by Christopher Petit on 3/17/25.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var translationHistory: [Translation] = []
    @State private var showHistory = false
    @State private var isTranslating = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // Input text field
                TextField("Enter text...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Translate button
                Button(action: translateText) {
                    HStack {
                        if isTranslating {
                            ProgressView()
                        }
                        Text("Translate Me")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(isTranslating)

                // Output translated text
                TextEditor(text: $translatedText)
                    .frame(height: 150)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    .disabled(true)

                // View history button
                Button(action: { showHistory = true }) {
                    Text("View Saved Translations")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("TranslateMe App")
            .onAppear(perform: loadHistory)
            .sheet(isPresented: $showHistory) {
                TranslationHistory(translationHistory: $translationHistory)
            }
        }
    }

    // Translate text
    func translateText() {
        guard !inputText.isEmpty else { return }
        isTranslating = true
        TranslationService.shared.translate(text: inputText) { result in
            DispatchQueue.main.async {
                isTranslating = false
                if let translation = result {
                    translatedText = translation
                    let newTranslation = Translation(id: UUID().uuidString, original: inputText, translated: translatedText)
                    translationHistory.insert(newTranslation, at: 0)
                    FirebaseService.shared.saveTranslation(original: inputText, translated: translatedText)
                } else {
                    translatedText = "Translation failed"
                }
                inputText = ""
            }
        }
    }

    // Load history from Firebase
    func loadHistory() {
        FirebaseService.shared.fetchTranslations { translations in
            DispatchQueue.main.async {
                translationHistory = translations
            }
        }
    }
}


struct Translation: Identifiable {
    var id: String = UUID().uuidString  // Default UUID if Firestore doesn't provide an ID
    var original: String
    var translated: String
}

#Preview {
    ContentView()
}
