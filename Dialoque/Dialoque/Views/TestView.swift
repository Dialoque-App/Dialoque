////
////  TestView.swift
////  Dialoque
////
////  Created by Daniel Aprillio on 14/08/23.
////
//
//import SwiftUI
//import CoreData
//import CloudKit
//import CoreHaptics
//import SwiftSpeech
//import WidgetKit
//
//struct TestView: View {
//    @State var yourLocaleString = "en_US"
//    @State private var engine: CHHapticEngine?
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    
////    @EnvironmentObject var statController: StatController
//    @EnvironmentObject var gameKitController: GameKitController
//    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Point.timestamp, ascending: true)],
//        animation: .default)
//    private var fetchedPoint: FetchedResults<Point>
//    
//    @State var isPresented = false
//    @State private var recognizedText = ""
//    @State private var isRecording = false
//    @State private var isSessionOver = true
//    
//    var labelStyle: some LabelStyle {
//#if os(watchOS)
//        return IconOnlyLabelStyle()
//#else
//        return DefaultLabelStyle()
//#endif
//    }
//    
//    @AppStorage("streak", store: UserDefaults.group) var streak: Int = 0
//    @AppStorage("points", store: UserDefaults.group) var points: Int = 0
//    
//    var body: some View {
//        NavigationView {
//            VStack{
//                VStack {
//                    
//                    HStack {
//                        Button(action: {
//                            streak -= 1
//                        }) {
//                            Image(systemName: "minus.circle")
//                                .font(.title)
//                        }
//                        Text("Streak: \(streak)")
//                        Button(action: {
//                            streak += 1
//                        }) {
//                            Image(systemName: "plus.circle")
//                                .font(.title)
//                        }
//                    }
//                    
//                    HStack {
//                        Button(action: {
//                            points -= 1
//                        }) {
//                            Image(systemName: "minus.circle")
//                                .font(.title)
//                        }
//                        Text("Points: \(points)")
//                        Button(action: {
//                            points += 1
//                        }) {
//                            Image(systemName: "plus.circle")
//                                .font(.title)
//                        }
//                    }
//
//                    Button("Set Widget") {
//                        UserDefaults.group?.synchronize()
//                        WidgetCenter.shared.reloadTimelines(ofKind: "Dialoque Widget")
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .padding()
//                
//                Button(
//                    action: {
//                        isSessionOver = !isSessionOver
//                    }
//                ){
//                    Text(isSessionOver ? "Start" : "End")
//                }
//                
//                Text("Recognized Text: \(recognizedText)")
//                
//                if !isSessionOver {
//                    SwiftSpeech.RecordButton()
//                        .swiftSpeechRecordOnHold(
//                            sessionConfiguration: SwiftSpeech.Session.Configuration(locale: Locale(identifier: "en-US")),
//                            animation: .linear(duration: 0.3),
//                            distanceToCancel: 100
//                        )
//                        .onRecognizeLatest(
//                            includePartialResults: false,
//                            update: $recognizedText
//                        )
//                        .onStartRecording { session in
//                            isRecording = true
//                        }
//                        .onStopRecording { session in
//                            isRecording = false
//                            createPoint(timestamp: .now)
//                        }
//                        .foregroundColor(isRecording ? .red : .blue)
//                }
//                
//                Text("\(fetchedPoint.count)")
//                    .font(.largeTitle)
//                
//                HStack{
//                    Text("Score:")
//                    Text("\(fetchedPoint.count)")
//                    Button(
//                        action: {
//                            createPoint(timestamp: .now)
//                        }
//                    ){
//                        Text("+").bold()
//                    }
//                }
//                
//                
//                Text("isPressed: \(isRecording.description)")
//                
//                Group{
//                    Text("Success Haptics")
//                        .foregroundColor(.green)
//                        .onTapGesture{simpleHaptics(type: "success")}
//                    Text("Error Haptics")
//                        .foregroundColor(.red)
//                        .onTapGesture{simpleHaptics(type: "error")}
//                    Text("Custom Haptics")
//                        .foregroundColor(.blue)
//                        .onTapGesture{customHaptics()}
//                }
//                
//                Button{
//                    isPresented = true
//                } label: {
//                    Text("Leaderboard")
//                        .bold()
//                        .foregroundColor(.indigo)
//                }
//                .fullScreenCover(isPresented: $isPresented) {
//                    GameCenterView().ignoresSafeArea()
//                }
//                
//                Group{
//                    Button{
//                        gameKitController.reportAchievement(identifier: "com.nielio.Dialoque.achievement.luckyClover")
//                    } label: {
//                        Text("get achievement")
//                    }
//                    
//                    Button{
//                        requestNotificationsPermission()
//                    } label: {
//                        Text("Request Notification Permission").foregroundColor(.orange)
//                    }
//                    Button{
//                        subscribeNotifications()
//                    } label: {
//                        Text("Subscribe Notification")
//                    }
//                    Button{
//                        unSubscribeNotifications()
//                    } label: {
//                        Text("Unsubscribe Notification")
//                    }
//                }
//                
//            }
//            .onChange(of: isSessionOver) { sessionOver in
//                if sessionOver {
//                    gameKitController.reportScore(score: fetchedPoint.count)
//                }
//            }
//            .onAppear {
//                SwiftSpeech.requestSpeechRecognitionAuthorization()
//                prepareCustomHaptics()
//            }
//        }
//    }
//    
//    func createPoint(timestamp: Date) {
//        PersistenceController.shared.createPoint(timestamp: timestamp)
//    }
//    
//    func requestNotificationsPermission(){
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options){success, error in
//            if let error = error{
//                print("Error: \(error.localizedDescription)")
//            } else if success {
//                print("Notification permission granted")
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            } else {
//                print("Notification permission failure")
//            }
//        }
//    }
//    
//    func subscribeNotifications(){
//        let predicate = NSPredicate(value: true)
//        let subscription = CKQuerySubscription(recordType: "CD_Point", predicate: predicate, subscriptionID: "point_added_to_cloud", options: .firesOnRecordCreation)
//        
//        let notification = CKSubscription.NotificationInfo()
//        notification.title = "New Score submitted!"
//        notification.alertBody = "Open app to check your score."
//        notification.soundName = "default"
//        
//        subscription.notificationInfo = notification
//        
//        CKContainer.default().privateCloudDatabase.save(subscription){ returnedSubscription, returnedError in
//            if let error = returnedError{
//                print(error)
//            } else {
//                print("Successfully subscribed notifications")
//            }
//        }
//        
//    }
//    
//    func unSubscribeNotifications(){
//        CKContainer.default().privateCloudDatabase.delete(withSubscriptionID: "point_added_to_cloud"){ returnedID, returnedError in
//            if let error = returnedError{
//                print(error)
//            } else {
//                print("Successfully unsubscribed notifications")
//            }
//        }
//    }
//    
//    func simpleHaptics(type: String){
//        let generator = UINotificationFeedbackGenerator()
//        if type.lowercased() == "success"{
//            generator.notificationOccurred(.success)
//        } else if type.lowercased() == "warning" {
//            generator.notificationOccurred(.warning)
//        } else if type.lowercased() == "error" {
//            generator.notificationOccurred(.error)
//        }
//    }
//    
//    func prepareCustomHaptics(){
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
//        
//        do {
//            engine = try CHHapticEngine()
//            try engine?.start()
//        } catch {
//            print("CHHapticEngine Error: \(error.localizedDescription)")
//        }
//    }
//    
//    func customHaptics(){
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
//        
//        var events = [CHHapticEvent]()
//        
//        for i in stride(from: 0, to: 1, by: 0.25){
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i)) //min=0 || max=1
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i)) //min=0 || max=1
//            
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: i)
//            events.append(event)
//        }
//        
//        //Another example of customizing haptics
//        for i in stride(from: 0, to: 1, by: 0.25){
//            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1-i)) //min=0 || max=1
//            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1-i)) //min=0 || max=1
//            
//            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 1+i)
//            events.append(event)
//        }
//        
//        do{
//            let pattern = try CHHapticPattern(events: events, parameters: [])
//            let player = try engine?.makePlayer(with: pattern)
//            try player?.start(atTime: 0)
//        } catch {
//            print("Failed to play pattern: \(error.localizedDescription)")
//        }
//    }
//}
//
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        @StateObject var gameKitController = GameKitController()
//        
//        TestView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .environmentObject(gameKitController)
//    }
//}
//


import SwiftUI

struct SlammingImageView: View {
    @State private var isZoomed = false
    @State private var numb = 5

    var body: some View {
        HStack {
            PlayerScoreView(score: $numb)
                .padding(.trailing, 20)
                .padding(.top, 14)
                .padding(.bottom, 6)
                .foregroundColor(.black)
                .bold()
                .overlay(
                    Image("streak_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .scaleEffect(isZoomed ? 1.2 : 1.0)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.4)) {
                                isZoomed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                                withAnimation(.easeOut(duration: 0.02)) {
                                    isZoomed = false
                                }
                                numb += 5
                            }
                        }
                    ,alignment: .trailing
                )
                .transition(.slideAndFade())
        }
        .scaleEffect(3)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(Color(UIColor.systemGray))
    }
}

struct SlammingImageView_Previews: PreviewProvider {
    static var previews: some View {
        SlammingImageView()
    }
}
