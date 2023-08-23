////
////  ContentView.swift
////  Test Watch App
////
////  Created by Jevin Laudo on 2023-08-02.
////
//
//import SwiftUI
//
//struct DashboardView: View {
//    
//    @State private var isSessionOver = true
//    @State private var isRecording = false
//    @State private var recognizedText = ""
//    
//    @AppStorage("streak", store: UserDefaults.group) var streak: Int = 0
//    @AppStorage("points", store: UserDefaults.group) var points: Int = 0
//    
//    @AppStorage("streakStart", store: UserDefaults.group) var streakStart = Date().startOfDay.timeIntervalSince1970
//    @AppStorage("streakDeadline", store: UserDefaults.group) var streakDeadline = Date().endOfDay.timeIntervalSince1970
//    
//    
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @StateObject private var pointsCountManager: PointsCountManager
//    
//    init() {
//        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
//        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
//    }
//    
//    
//    @State private var selectedLanguage = "en"
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack {
//                    Text("Streak: \(points)")
//                    Text("Point: \(streak)")
//                }
//                .padding()
//                
//                VStack {
//                    Button(isSessionOver ? "Start" : "End") {
//                        isSessionOver.toggle()
//                    }
//                    
//                    if !isSessionOver {
//                        Button(action: {
//                            presentTextInputControllerForLanguage(language: selectedLanguage)
//                        }) {
//                            Image(systemName: "mic.fill")
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//                    
//                    Text("Recognized Text: \(recognizedText)")
//                        .padding()
//                    
//                    HStack {
//                        Text("Points: \(pointsCountManager.pointsCount)")
//                        Text("Streak: \(streak)")
//                    }
//                    Button("+") {
//                        pointsCountManager.createPoint(timestamp: .now)
//                    }
//                }
//            }
//        }
//        .onChange(of: pointsCountManager.pointsCount) { newCount in
//            points = newCount
//        }
//    }
//    
//    private func presentTextInputControllerForLanguage(language: String) {
//        WKExtension.shared().visibleInterfaceController?.presentTextInputControllerWithSuggestions(
//            forLanguage: { (inputLanguage) in
//                if inputLanguage == language {
//                    // Provide suggestions based on the selected language
//                    // You can customize this part to return appropriate suggestions
//                    return []
//                } else {
//                    return nil
//                }
//            },
//            allowedInputMode: .plain
//        ) { (results) in
//            if let input = results?.first as? String {
//                self.recognizedText = input
//            } else {
//                self.recognizedText = "No input"
//            }
//        }
//    }
//}
//
//
//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//    }
//}
