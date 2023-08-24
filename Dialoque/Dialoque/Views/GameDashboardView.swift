//
//  GameDashboardView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 14/08/23.
//

import SwiftUI
import SwiftSpeech
import Combine
import WidgetKit

struct GameDashboardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var gameKitController: GameKitController
    
    @State var isCharacterClicked = false
    @State var isGameCenterLeaderboardsPresented = false
    @State var isGameCenterAchievementsPresented = false
    
    @State var sessionStatus: GameStatus = .idle
    
    @State private var playerHealth = 3
    
    @State private var speechPrompt = "prompt"
    
    @State private var isSessionOngoing = false
    @State private var navigateToResult = false
    
    // Provides Binding for pulse animations
    @State private var isStartButtonPulsing = false
    @State private var isSpeechButtonPulsing = false
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    @AppStorage("points", store: UserDefaults.group) var points = 0
    
    
    @StateObject private var pointsCountManager: PointsCountManager
    @State private var pointsInSession = 0
    
    
    @State private var isStreakYetToday = false
    
    @State private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                PlayerPointsPanel(
                    sessionStatus: $sessionStatus,
                    streak: $streak,
                    points: $points,
                    onEndSession: {
                        endSession()
                    }
                )
                
                GeometryReader { geometry in
                    ZStack(alignment: .top){
                        VStack {
                            HStack {
                                switch sessionStatus {
                                case .idle:
                                    Image("leaderboard_icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                        .clipped()
                                        .onTapGesture {
                                            isGameCenterLeaderboardsPresented = true
                                        }
                                        .transition(.slideAndFade(direction: .leading))
                                        .fullScreenCover(isPresented: $isGameCenterLeaderboardsPresented) {
                                            GameCenterView(viewState: .leaderboards).ignoresSafeArea()
                                        }
                                    
                                    Spacer()
                                    
                                    Image("achievement_icon_white")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                        .clipped()
                                        .onTapGesture {
                                            isGameCenterAchievementsPresented = true
                                        }
                                        .transition(.slideAndFade(direction: .trailing))
                                        .fullScreenCover(isPresented: $isGameCenterAchievementsPresented) {
                                            GameCenterView(viewState: .achievements).ignoresSafeArea()
                                        }
                                case .ongoing:
                                    HStack(alignment: .center, spacing: 2){
                                        ForEach(0 ..< playerHealth, id:\.self){ _ in
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(Color.red)
                                                .font(.system(size: 32))
                                                .clipped()
                                                .transition(.slideAndFade(direction: .bottom))
                                        }
                                        ForEach(0 ..< 3 - playerHealth, id:\.self){ _ in
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(Color.gray)
                                                .font(.system(size: 32))
                                                .clipped()
                                        }
                                    }
                                    .animation(.easeInOut(duration: 0.5), value: sessionStatus)
                                    .transition(.slideAndFade(direction: .top))
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 35)
                            .transition(.slideAndFade(direction: .bottom))
                            .animation(.easeInOut(duration: 0.5).delay(0.1), value: sessionStatus)
                            Spacer()
                            
                            VStack {
                                switch sessionStatus {
                                case .idle:
                                    SessionButton (
                                        title: "START PRACTICE",
                                        foregroundColor: .white,
                                        backgroundColor: .accentColor,
                                        strokeColor: .darkGreen,
                                        horizontalPadding: 28,
                                        verticalPadding: 16
                                    )
                                    .font(.system(size: 26))
                                    .pulsingBackgroundShape (
                                        color: .accentColor,
                                        shape: Capsule(),
                                        isPulsing: $isStartButtonPulsing,
                                        maxXScale: 1.2,
                                        maxYScale: 1.5
                                    )
                                    .onTapGesture {
                                        startSession()
                                    }
                                    .padding(.bottom, geometry.size.height * 0.18)
                                    .transition(.slideAndFade(direction: .bottom))
                                case .ongoing:
                                    SwiftSpeech.RecordButton()
                                        .swiftSpeechRecordOnHold(
                                            sessionConfiguration: SwiftSpeech.Session.Configuration(locale: Locale(identifier: "en-US")),
                                            animation: .linear(duration: 0.3),
                                            distanceToCancel: 50
                                        )
                                        .onStopRecording { session in
                                            session.stopRecording() // Stop the recording session
                                            
                                            // Subscribe to the resultPublisher to receive recognition results
                                            session.resultPublisher?
                                                .sink (
                                                    receiveCompletion: { completion in
                                                        // Handle completion if needed
                                                        switch completion {
                                                        case .finished:
                                                            break
                                                        case .failure(let error):
                                                            print("Recognition result error: \(error)")
                                                        }
                                                    },
                                                    receiveValue: { result in
                                                        if result.isFinal {
                                                            // Call your function when recognition is finalized
                                                            checkPronunciation(result.bestTranscription.formattedString)
                                                        }
                                                    }
                                                )
                                                .store(in: &cancellables) // Store the subscription
                                        }
                                        .pulsingBackgroundShape(
                                            color: .accentColor,
                                            shape: Circle(),
                                            isPulsing: $isSpeechButtonPulsing,
                                            maxXScale: 1.5,
                                            maxYScale: 1.5
                                        )
                                        .font(.system(size: 50, weight: .medium, design: .default))
                                        .padding(.bottom, geometry.size.height * 0.08)
                                        .transition(.slideAndFade(direction: .bottom))
                                }
                            }
                            .animation(.easeInOut(duration: 0.6).delay(0.2), value: sessionStatus)
                        }
                        .zIndex(2)
                        
                        VStack {
                            Spacer()
                            ZStack {
                                if sessionStatus == .ongoing {
                                    VStack(alignment: .leading) {
                                        Text("Say this to me…")
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 18))
                                            .padding(.bottom, 5)
                                        
                                        Text(speechPrompt)
                                            .font(.system(size: 38))
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.01)
                                            .bold()
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(5)
                                            .background(Color(UIColor.systemGray6))
                                            .cornerRadius(40)
                                            .clipped()
                                            .padding(2)
                                            .background(.white)
                                            .cornerRadius(240)
                                            .clipped()
                                            .id("Prompt" + speechPrompt)
                                            .transition(.slideAndFade(direction: .leading))
                                        
                                        Spacer()
                                    }
                                    .animation(.easeInOut(duration: 0.7), value: speechPrompt)
                                    .transition(.slideAndFade(direction: .leading))
                                    .padding(.horizontal, 60)
                                    .padding(.top, 220)
                                    .zIndex(1)
                                    
                                    LinearGradient(
                                        gradient:
                                            Gradient(
                                                stops: [
                                                    .init(color: .clear, location: 0),
                                                    .init(color: Color(UIColor.systemGray6), location: 0.5)
                                                ]),
                                        startPoint: .top, endPoint: .bottom
                                    )
                                    .transition(.slideAndFade(direction: .bottom))
                                    .zIndex(0)
                                }
                            }
                            .frame(height: geometry.size.height * 0.75)
                        }
                        .animation(.easeInOut(duration: 0.7).delay(0.7), value: sessionStatus)
                        .zIndex(1)
                        
                        ZStack(alignment: .center) {
                            Image("flying_land")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, geometry.size.height * 0.35)
                                .clipped()
                            
                            Button (
                                action: {
                                    isCharacterClicked.toggle()
                                }
                            ) {
                                if(isCharacterClicked) {
                                    LottieView(lottieFile: "dialoque_character_mini_jump", loopMode: .loop)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: geometry.size.height * 0.44)
                                        .clipped()
                                        .padding(.bottom, geometry.size.height * 0.1)
                                } else {
                                    Image("character_default")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height:  geometry.size.height * 0.33)
                                        .clipped()
                                }
                            }
                            .padding(.bottom, geometry.size.height * 0.08)
                        }
                        .scaleEffect(isSessionOngoing ? 0.9 : 1.1)
                        .offset(y: isSessionOngoing ? -10 : 0)
                        .onChange(of: sessionStatus) { newStatus in
                            if newStatus == .ongoing {
                                generateRandomPrompt()
                            }
                            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                                isSessionOngoing = newStatus == .ongoing
                            }
                        }
                        .zIndex(0)
                    }
                }
            }
            .ignoresSafeArea()
            .background(Color(UIColor.systemGray6))
            .onAppear {
                requestNotificationsPermission()
                setUpLocalNotification(hour: 8, minute: 0)
                streak = updateStreaksCount(context: viewContext)
                points = pointsCountManager.pointsCount
                isStreakYetToday = pointsCountManager.isPointScoredToday()
                updateStorageStreakYetToday(value: isStreakYetToday)
            }
            .onChange(of: pointsCountManager.pointsCount) { newPoint in
                streak = updateStreaksCount(context: viewContext)
                points = newPoint
            }
            .onChange(of: playerHealth) { health in
                if health <= 0 {
                    endSession()
                }
            }
            .onChange(of: isStreakYetToday) { value in
                updateStorageStreakYetToday(value: value)
            }
            .navigationDestination(isPresented: $navigateToResult) {
                let streakAdded = !isStreakYetToday && pointsInSession > 0 ? 1 : 0
                GameResultView(
                    pointCount: pointsInSession,
                    streakCount: streakAdded
                )
                .navigationBarBackButtonHidden()
                .onDisappear {
                    sessionStatus = .idle
                    isStartButtonPulsing = false
                    isSpeechButtonPulsing = false
                    pointsInSession = 0
                }
            }
            .onChange(of: streak) { _ in
                refreshWidget()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func requestNotificationsPermission(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options){success, error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            } else if success {
                print("Notification permission granted")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission failure")
            }
        }
    }
    
    func setUpLocalNotification(hour: Int, minute: Int) {

        // have to use NSCalendar for the components
        let calendar = NSCalendar(identifier: .gregorian)!;

        var dateFire = Date()

        // if today's date is passed, use tomorrow
        var fireComponents = calendar.components( [NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from:dateFire)

        if (fireComponents.hour! > hour
            || (fireComponents.hour == hour && fireComponents.minute! >= minute) ) {

            dateFire = dateFire.addingTimeInterval(86400)  // Use tomorrow's date
            fireComponents = calendar.components( [NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from:dateFire);
        }

        // set up the time
        fireComponents.hour = hour
        fireComponents.minute = minute

        // schedule local notification
        dateFire = calendar.date(from: fireComponents)!

        let localNotification = UILocalNotification()
        localNotification.fireDate = dateFire
        localNotification.alertTitle = "It's Time to Learn!"
        localNotification.alertBody = "Keep your streak alive, don't miss a day on Dialoque."
        localNotification.repeatInterval = NSCalendar.Unit.day
        localNotification.soundName = UILocalNotificationDefaultSoundName;

        UIApplication.shared.scheduleLocalNotification(localNotification);
    }
    
    func startSession() {
        sessionStatus = .ongoing
        playerHealth = 3
        isStartButtonPulsing = false
        isSpeechButtonPulsing = false
        navigateToResult = false
        isStreakYetToday = pointsCountManager.isPointScoredToday()
    }
    
    func endSession() {
        if pointsInSession > 0 {
            navigateToResult = true
        } else {
            sessionStatus = .idle
            isStartButtonPulsing = false
            isSpeechButtonPulsing = false
            pointsInSession = 0
        }
    }
    
    func checkPronunciation(_ recognisedSpeech: String) {
        if recognisedSpeech.uppercased().contains(speechPrompt.uppercased()) {
            // Correct Pronunciation
            pointsInSession += 1
            pointsCountManager.createPoint(timestamp: .now)
            if playerHealth < 3 {
                playerHealth += 1
            }
            simpleHaptics(hapticType: "correct")
        } else {
            // Inorrect Pronunciation
            playerHealth -= 1
            simpleHaptics(hapticType: "incorrect")
        }
        generateRandomPrompt()
    }
    
    func generateRandomPrompt() {
        speechPrompt = promptArray.randomElement()?.uppercased() ?? "PROMPT"
    }
    
    func updateStorageStreakYetToday(value: Bool) {
        UserDefaults.group?.set(value, forKey: "isTodayStreakYet")
        refreshWidget()
    }
    
    func simpleHaptics(hapticType: String) {
        let generator = UINotificationFeedbackGenerator()
        if hapticType == "correct" {
            generator.notificationOccurred(.success)
        } else if hapticType == "incorrect" {
            generator.notificationOccurred(.error)
        }
    }
    
    func refreshWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "Dialoque Widget")
    }
}
