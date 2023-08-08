//
//  DialoqueApp.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI

@main
struct DialoqueApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var gameKitController = GameKitController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(gameKitController)
        }
    }
}
