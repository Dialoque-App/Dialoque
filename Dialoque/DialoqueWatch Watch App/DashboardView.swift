//
//  ContentView.swift
//  Test Watch App
//
//  Created by Jevin Laudo on 2023-08-02.
//

import SwiftUI

struct DashboardView: View {
    let publisher  = NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        .receive(on: RunLoop.main)
    @State private var receiveNotification = false
    
    @State private var isSessionOver = true
    @State private var isRecording = false
    @State private var recognizedText = ""
    
    @AppStorage("streak", store: UserDefaults.group) var streak: Int = 0
    @AppStorage("points", store: UserDefaults.group) var points: Int = 0
    
    @AppStorage("streakStart", store: UserDefaults.group) var streakStart = Date().startOfDay.timeIntervalSince1970
    @AppStorage("streakDeadline", store: UserDefaults.group) var streakDeadline = Date().endOfDay.timeIntervalSince1970
    
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var pointsCountManager: PointsCountManager
    
    let formatter = DateFormatter()
    init() {
        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    
    @State private var selectedLanguage = "en"
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("AppStorage")
                    Text(
                        formatter.string(
                            from: Date(timeIntervalSince1970: streakStart)
                        )
                    )
                    
                    Text(formatter.string(from: Date(timeIntervalSince1970: streakDeadline)))
                    
                    Spacer().frame(height: 15)
                    
                    Text("iCloud")
                    Text(formatter.string(from: Date(timeIntervalSince1970: NSUbiquitousKeyValueStore.ubiquitousStreakStart)))
                    
                    Text(formatter.string(from: Date(timeIntervalSince1970: NSUbiquitousKeyValueStore.ubiquitousStreakDeadline)))
                }
                .padding()
                
                VStack{
                    Button("Update Local Streak") {
                        synchronizeStreak()
                        if updateStreakToday() { // resync if streak is updated
                            synchronizeStreak()
                        }
                    }
                    .padding()
                    Button("Sync Streak") {
                        synchronizeStreak()
                    }
                    .padding()
                }
                
                VStack {
                    Button(isSessionOver ? "Start" : "End") {
                        isSessionOver.toggle()
                    }
                    
                    if !isSessionOver {
                        Button(action: {
                            presentTextInputControllerForLanguage(language: selectedLanguage)
                        }) {
                            Image(systemName: "mic.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Text("Recognized Text: \(recognizedText)")
                        .padding()
                    
                    HStack {
                        Text("Points: \(pointsCountManager.pointsCount)")
                        Text("Streak: \(streak)")
                    }
                    Button("+") {
                        createPoint(timestamp: .now)
                    }
                }
            }
        }
        .onChange(of: pointsCountManager.pointsCount) { newCount in
            points = newCount
        }
        .onChange(of: receiveNotification) { receive in
            if receive {
                synchronizeStreak()
            }
        }
    }
    
    private func presentTextInputControllerForLanguage(language: String) {
        WKExtension.shared().visibleInterfaceController?.presentTextInputControllerWithSuggestions(
            forLanguage: { (inputLanguage) in
                if inputLanguage == language {
                    // Provide suggestions based on the selected language
                    // You can customize this part to return appropriate suggestions
                    return []
                } else {
                    return nil
                }
            },
            allowedInputMode: .plain
        ) { (results) in
            if let input = results?.first as? String {
                self.recognizedText = input
            } else {
                self.recognizedText = "No input"
            }
        }
    }
    
    func createPoint(timestamp: Date) {
        PersistenceController.shared.createPoint(timestamp: timestamp)
    }
    
    func updateStreakToday() -> Bool {
        let today = Date().startOfDay.timeIntervalSince1970
        let tomorrowEnd = today + 86400 + 86399
        
        // Return early if streakDeadline is already set to tomorrow.
        if streakDeadline == tomorrowEnd {
            return false
        }
        
        if streakStart <= today && today <= streakDeadline {
            streakDeadline = tomorrowEnd
        } else {
            // If today is not within the current streak period, set new streak start and deadline.
            streakStart = today
            streakDeadline = tomorrowEnd
        }
        return true
    }
    
    func synchronizeStreak() {
        let icloudStart = NSUbiquitousKeyValueStore.ubiquitousStreakStart
        let icloudDeadline = NSUbiquitousKeyValueStore.ubiquitousStreakDeadline
        
        // Ensure valid start and deadline order
        if streakStart > streakDeadline {
            // Correct invalid local data
            streakStart = Date().startOfDay.timeIntervalSince1970
            streakDeadline = Date().endOfDay.timeIntervalSince1970
        }
        
        if icloudStart > icloudDeadline {
            // Correct invalid iCloud data
            NSUbiquitousKeyValueStore.ubiquitousStreakStart =  Date().startOfDay.timeIntervalSince1970
            NSUbiquitousKeyValueStore.ubiquitousStreakDeadline =  Date().endOfDay.timeIntervalSince1970
        }
        
        // Handle conflicts or simultaneous updates
        if streakStart == icloudStart {
            let maxDeadline = max(streakDeadline, icloudDeadline)
            streakDeadline = maxDeadline
            NSUbiquitousKeyValueStore.ubiquitousStreakDeadline = maxDeadline
        } else if streakDeadline <= icloudStart {
            streakDeadline = icloudDeadline
            NSUbiquitousKeyValueStore.ubiquitousStreakStart = streakStart
        } else if streakStart <= icloudDeadline {
            streakStart = icloudStart
            NSUbiquitousKeyValueStore.ubiquitousStreakDeadline = streakDeadline
        } else {
            // Assign which values are more recent atomically
            if streakDeadline < icloudDeadline {
                streakStart = icloudStart
                streakDeadline = icloudDeadline
            } else {
                NSUbiquitousKeyValueStore.ubiquitousStreakStart = streakStart
                NSUbiquitousKeyValueStore.ubiquitousStreakDeadline = streakDeadline
            }
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
