//
//  ContentView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI
import CoreData
import CloudKit
import CoreHaptics
import SwiftSpeech
import WidgetKit

struct DashboardView: View {
    let publisher = NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        .receive(on: RunLoop.main)
    @State private var receiveNotification = false
    
    @State var yourLocaleString = "en_US"
    @State private var engine: CHHapticEngine?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var statController: StatController
    @EnvironmentObject var gameKitController: GameKitController
    
    @State var isPresented = false
    @State private var recognizedText = ""
    @State private var isRecording = false
    @State private var isSessionOver = true
    
    @StateObject private var pointsCountManager: PointsCountManager
    
    let formatter = DateFormatter()
    init() {
        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    @AppStorage("points", store: UserDefaults.group) var points = 0
    
    @AppStorage("streakStart", store: UserDefaults.group) var streakStart = Date().startOfDay.timeIntervalSince1970
    @AppStorage("streakDeadline", store: UserDefaults.group) var streakDeadline = Date().endOfDay.timeIntervalSince1970
    
    
    var body: some View {
        NavigationView {
            VStack{
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
                    Button("Update Streak") {
                        synchronizeStreak()
                        if updateStreakToday() { // resync if streak is updated
                        }
                    }
                    .padding()
                    Button("Sync Streak") {
                        synchronizeStreak()
                    }
                    .padding()
                }
                Button("Set Widget") {
                    points = pointsCountManager.pointsCount
                    UserDefaults.group?.synchronize()
                    WidgetCenter.shared.reloadTimelines(ofKind: "Dialoque Widget")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
                Button(
                    action: {
                        isSessionOver = !isSessionOver
                    }
                ){
                    Text(isSessionOver ? "Start" : "End")
                }
                
                Text("Recognized Text: \(recognizedText)")
                
                if !isSessionOver {
                    SwiftSpeech.RecordButton()
                        .swiftSpeechRecordOnHold(
                            sessionConfiguration: SwiftSpeech.Session.Configuration(locale: Locale(identifier: "en-US")),
                            animation: .linear(duration: 0.3),
                            distanceToCancel: 100
                        )
                        .onRecognizeLatest(
                            includePartialResults: false,
                            update: $recognizedText
                        )
                        .onStartRecording { session in
                            isRecording = true
                        }
                        .onStopRecording { session in
                            isRecording = false
                            createPoint(timestamp: .now)
                        }
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                Text("\(pointsCountManager.pointsCount)")
                    .font(.largeTitle)
                
                HStack{
                    Text("Score:")
                    Text("\(pointsCountManager.pointsCount)")
                    Button(
                        action: {
                            createPoint(timestamp: .now)
                        }
                    ){
                        Text("+").bold()
                    }
                }
                
                
                Text("isPressed: \(isRecording.description)")
                
                Button(action: { isPresented = true }) {
                    Text("Leaderboard")
                        .bold()
                        .foregroundColor(.indigo)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    GameCenterView()
                        .ignoresSafeArea()
                }
            }
            .onChange(of: isSessionOver) { sessionOver in
                if sessionOver {
                    gameKitController.reportScore(totalScore: pointsCountManager.pointsCount)
                }
            }
            .onChange(of: receiveNotification) { receive in
                if receive {
                    synchronizeStreak()
                }
            }
            .onAppear {
                SwiftSpeech.requestSpeechRecognitionAuthorization()
            }
        }
        .onReceive(publisher, perform: { publisher in
            if publisher.name == NSUbiquitousKeyValueStore.didChangeExternallyNotification {
                receiveNotification = true
            }
        })
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
        NSUbiquitousKeyValueStore.default.synchronize()
        
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
        } else if
            (streakDeadline >= icloudStart && streakStart <= icloudDeadline) ||
                (icloudDeadline >= streakStart && icloudStart <= streakDeadline) {
            //handle streak continuity
            assignNewStreak(min(streakStart, icloudStart), max(streakDeadline, icloudDeadline))
        } else {
            // When no continuous streak on both
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
    
    func assignNewStreak(_ start: Double, _ deadline: Double) {
        streakStart = start
        NSUbiquitousKeyValueStore.ubiquitousStreakStart = start
        streakDeadline = deadline
        NSUbiquitousKeyValueStore.ubiquitousStreakDeadline = deadline
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var gameKitController = GameKitController()
        
        DashboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(gameKitController)
    }
}
