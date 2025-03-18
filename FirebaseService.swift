//
//  FirebaseService.swift
//  TranslateMe
//
//  Created by Christopher Petit on 3/17/25.
//

import Foundation
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    private let collection = "translations"

    // Save translation to Firestore
    func saveTranslation(original: String, translated: String) {
        let translation: [String: Any] = [
            "original": original,
            "translated": translated,
            "timestamp": Timestamp()
        ]
        db.collection(collection).addDocument(data: translation)
    }

    // Fetch translations from Firestore
    func fetchTranslations(completion: @escaping ([Translation]) -> Void) {
        db.collection(collection).order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                completion([])
                return
            }

            // Map Firestore documents to Translation objects
            let translations = documents.compactMap { doc -> Translation? in
                let data = doc.data()
                guard let original = data["original"] as? String,
                      let translated = data["translated"] as? String else { return nil }
                return Translation(id: doc.documentID, original: original, translated: translated)
            }
            completion(translations)
        }
    }

    // Clear all translations in Firestore
    func clearHistory(completion: @escaping (Bool) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                completion(false)
                return
            }

            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    }
                }
            }
            completion(true)
        }
    }
}
