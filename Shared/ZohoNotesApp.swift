//
//  ZohoNotesApp.swift
//  Shared
//
//  Created by Mahesh sai on 02/06/22.
//

import SwiftUI

@main
struct ZohoNotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
