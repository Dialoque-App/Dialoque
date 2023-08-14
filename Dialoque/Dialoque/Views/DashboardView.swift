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
    
    @EnvironmentObject var gameKitController: GameKitController
    
    @StateObject private var pointsCountManager: PointsCountManager
    
    @State var isPresented = false
    @State private var recognizedText = ""
    @State private var isRecording = false
    @State private var isSessionOver = true
    
    init() {
        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
    }
    
    @AppStorage("streak", store: UserDefaults.group) var streak: Int = 0
    @AppStorage("points", store: UserDefaults.group) var points: Int = 0
    
    var body: some View {
        NavigationView {
            VStack{
                VStack {
                    Button("Set Widget") {
                        UserDefaults.group?.synchronize()
                        WidgetCenter.shared.reloadTimelines(ofKind: "Dialoque Widget")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
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
                
                Button{
                    isPresented = true
                } label: {
                    Text("Leaderboard")
                        .bold()
                        .foregroundColor(.indigo)
                }
                .fullScreenCover(isPresented: $isPresented) {
                    GameCenterView().ignoresSafeArea()
                }
                
            }
            .onChange(of: isSessionOver) { sessionOver in
                if sessionOver {
                    gameKitController.reportScore(score: pointsCountManager.pointsCount)
                }
            }
            .onAppear {
                SwiftSpeech.requestSpeechRecognitionAuthorization()
            }
        }
    }
    
    func createPoint(timestamp: Date) {
        PersistenceController.shared.createPoint(timestamp: timestamp)
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
