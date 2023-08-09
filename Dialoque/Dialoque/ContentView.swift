//
//  ContentView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI
import CoreData
import SwiftSpeech
import WidgetKit


struct ContentView: View {
    @State var yourLocaleString = "en_US"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var statController: StatController
    @EnvironmentObject var gameKitController: GameKitController
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Point.timestamp, ascending: true)],
        animation: .default)
    private var fetchedPoint: FetchedResults<Point>
    
    @State var isPresented = false
    @State private var recognizedText = ""
    @State private var isRecording = false
    @State private var isSessionOver = true
    
    var labelStyle: some LabelStyle {
    #if os(watchOS)
        return IconOnlyLabelStyle()
    #else
        return DefaultLabelStyle()
    #endif
    }
    
    @AppStorage("streak", store: UserDefaults.group) var streak: Int = 0
    @AppStorage("points", store: UserDefaults.group) var points: Int = 0
    
    var body: some View {
        NavigationView {
            VStack{
                VStack {
                    
                    HStack {
                        Button(action: {
                            streak -= 1
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.title)
                        }
                        Text("Streak: \(streak)")
                        Button(action: {
                            streak += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            points -= 1
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.title)
                        }
                        Text("Points: \(points)")
                        Button(action: {
                            points += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                    }

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
                ) {
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
                
                Text("\(fetchedPoint.count)")
                    .font(.largeTitle)
                
                HStack{
                    Text("Score:")
                    Text("\(fetchedPoint.count)")
                    Button(
                        action: {
                            createPoint(timestamp: .now)
                        }
                    ){
                        Text("+").bold()
                    }
                }
                
                Text("isPressed: \(isRecording.description)")
                
                Button(action: {
                    isPresented = true
                }){
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
                    gameKitController.reportScore(totalScore: fetchedPoint.count)
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var gameKitController = GameKitController()
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(gameKitController)
    }
}
