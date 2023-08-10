//
//  ContentView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 28/07/23.
//

import SwiftUI
import CoreData
import CoreHaptics
import SwiftSpeech


struct ContentView: View {
    @State var yourLocaleString = "en_US"
    @State private var engine: CHHapticEngine?
    
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
                    Button{
                        createPoint(timestamp: .now)
                    } label: {
                        Text("+").bold()
                    }
                }
                
                Text("isPressed: \(isRecording.description)")
                
                Text("Success Haptics")
                    .foregroundColor(.green)
                    .onTapGesture{simpleHaptics(type: "success")}
                Text("Error Haptics")
                    .foregroundColor(.red)
                    .onTapGesture{simpleHaptics(type: "error")}
                Text("Custom Haptics")
                    .foregroundColor(.blue)
                    .onTapGesture{customHaptics()}
                
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
                    gameKitController.reportScore(totalScore: points.count)
                }
            }
            .onAppear {
                SwiftSpeech.requestSpeechRecognitionAuthorization()
                prepareCustomHaptics()
            }
        }
    }
    
    func createPoint(timestamp: Date) {
        PersistenceController.shared.createPoint(timestamp: timestamp)
    }
    
    func simpleHaptics(type: String){
        let generator = UINotificationFeedbackGenerator()
        if type.lowercased() == "success"{
            generator.notificationOccurred(.success)
        } else if type.lowercased() == "warning" {
            generator.notificationOccurred(.warning)
        } else if type.lowercased() == "error" {
            generator.notificationOccurred(.error)
        }
    }
    
    func prepareCustomHaptics(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("CHHapticEngine Error: \(error.localizedDescription)")
        }
    }
    
    func customHaptics(){
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.25){
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i)) //min=0 || max=1
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i)) //min=0 || max=1

            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: i)
            events.append(event)
        }
        
        //Another example of customizing haptics
        for i in stride(from: 0, to: 1, by: 0.25){
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1-i)) //min=0 || max=1
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1-i)) //min=0 || max=1
            
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 1+i)
            events.append(event)
        }
        
        do{
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
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
