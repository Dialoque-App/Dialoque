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
    @State private var pointsInSession = 0
    
    @State private var isStreakYetToday = false
    
    init() {
        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
    }
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    
    @AppStorage("points", store: UserDefaults.group) var points = 0


    var body: some View {
        NavigationView {
            VStack{
                VStack {
                    Text("Total Points")
                    Text("\(pointsCountManager.pointsCount)")
                        .font(.largeTitle)
                }
                
                VStack {
                    Text("Streak: \(streak)")
                    Text("Point: \(points)")
                }
                .padding()
                
                Button("Reset Points") {
                    pointsCountManager.resetPoint()
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
                
                Text("isStreakYetToday: \(isStreakYetToday ? "true" : "false")")
                
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
                        }
                        .foregroundColor(isRecording ? .red : .blue)
                    
                    HStack{
                        Text("Score in session: \(pointsInSession)")
                        Button(
                            action: {
                                pointsInSession += 1
                                pointsCountManager.createPoint(timestamp: .now)
                            }
                        ){
                            Text("+").bold()
                        }
                    }
                }
                
                
                
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
                    points += pointsInSession
                    gameKitController.reportScore(totalScore: pointsCountManager.pointsCount)
                    if !isStreakYetToday {
                        streak += 1
                        isStreakYetToday = true
                    }
                    pointsInSession = 0
                }
            }
            .onAppear {
                points = pointsCountManager.pointsCount
                streak = updateStreaksCount(context: viewContext)
                SwiftSpeech.requestSpeechRecognitionAuthorization()
                isStreakYetToday = pointsCountManager.isPointScoredToday()
            }
        }
        
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
