//
//  ContentView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI
import CoreData
import SwiftSpeech


struct ContentView: View {
    @State var yourLocaleString = "en_US"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var statController: StatController
    @EnvironmentObject var gameKitController: GameKitController
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Point.timestamp, ascending: true)],
        animation: .default)
    private var points: FetchedResults<Point>
    
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
    
    var body: some View {
        NavigationView {
            VStack{
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
                
                Text("\(points.count)")
                    .font(.largeTitle)
                
                HStack{
                    Text("Score:")
                    Text("\(points.count)")
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
                    gameKitController.reportScore(totalScore: points.count)
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var gameKitController = GameKitController()
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(gameKitController)
    }
}
