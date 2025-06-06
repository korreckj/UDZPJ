//
//  UDZPJApp.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 1/25/24.
//

import SwiftUI
import SwiftData

@main
struct UDZPJApp: App {
    // setup for the ml model
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PhotoEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
