//
//  Dex3App.swift
//  Dex3
//
//  Created by Raja Adeel Ahmed on 4/7/23.
//

import SwiftUI

@main
struct Dex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
