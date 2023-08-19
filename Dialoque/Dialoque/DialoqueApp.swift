//
//  DialoqueApp.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    
}


@main
struct DialoqueApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let persistenceController = PersistenceController.shared
    @StateObject var gameKitController = GameKitController()
    
    var body: some Scene {
        WindowGroup {
            GameDashboardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(gameKitController)
        }
    }
}
