//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Christopher Petit on 3/17/25.
//

import SwiftUI
import Firebase

@main
struct TranslationMeApp: App {
    init() {
        // Initialize Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

