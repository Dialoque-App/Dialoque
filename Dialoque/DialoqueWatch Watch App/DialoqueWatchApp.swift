//
//  DialoqueWatchApp.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 04/08/23.
//

import SwiftUI

@main
struct DialoqueWatch_Watch_AppApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            GameDashboardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .onAppear{
//                    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//                    print(urls[urls.count - 1] as URL)
//                }
        }
    }
}
