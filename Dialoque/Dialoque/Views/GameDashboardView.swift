//
//  GameDashboardView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 14/08/23.
//

import SwiftUI
import SwiftSpeech

struct GameDashboardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var gameKitController: GameKitController
    
    @State var isCharacterClicked = false
    @State var isGameCenterPresented = false
    
    @State var sessionStatus: GameStatus = .idle
    
    @State private var playerHealth = 3
    
    @State private var speechPrompt = "HAPPY"
    
    @State private var recognisedSpeech = ""
    
    @State private var isRecording = false
    
    @State private var isSessionOngoing = false
    
    // Provides Binding for pulse animations
    @State private var isStartButtonPulsing = false
    @State private var isSpeechButtonPulsing = false
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    @AppStorage("points", store: UserDefaults.group) var points = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                PlayerPointsPanel(
                    sessionStatus: $sessionStatus,
                    streak: $streak,
                    points: $points
                )
                
                GeometryReader { geometry in
                    ZStack(alignment: .top){
                        VStack {
                            HStack {
                                switch sessionStatus {
                                case .idle, .end:
                                    Image("leaderboard_icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                        .clipped()
                                        .onTapGesture {
                                            isGameCenterPresented = true
                                        }
                                        .fullScreenCover(isPresented: $isGameCenterPresented) {
                                            GameCenterView().ignoresSafeArea()
                                        }
                                        .transition(.slideAndFade(direction: .leading))
                                    
                                    Spacer()
                                    
                                    Image("achievement_icon_white")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                        .clipped()
                                        .onTapGesture {
                                            isGameCenterPresented = true
                                        }
                                        .fullScreenCover(isPresented: $isGameCenterPresented) {
                                            GameCenterView().ignoresSafeArea()
                                        }
                                        .transition(.slideAndFade(direction: .trailing))
                                case .ongoing:
                                    HStack(alignment: .center, spacing: 2){
                                        ForEach(0 ..< playerHealth, id:\.self){ _ in
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(Color.red)
                                                .font(.system(size: 32))
                                                .clipped()
                                        }
                                        ForEach(0 ..< 3 - playerHealth, id:\.self){ _ in
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(Color.gray)
                                                .font(.system(size: 32))
                                                .clipped()
                                        }
                                    }
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
                                case .idle, .end:
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
                                            distanceToCancel: 100
                                        )
                                        .onRecognizeLatest(
                                            includePartialResults: false,
                                            update: $recognisedSpeech
                                        )
                                        .onStartRecording { session in
                                            isRecording = true
                                        }
                                        .onStopRecording { session in
                                            isRecording = false
                                        }
                                        .pulsingBackgroundShape(
                                            color: .accentColor,
                                            shape: Circle(),
                                            isPulsing: $isSpeechButtonPulsing,
                                            maxXScale: 1.5,
                                            maxYScale: 1.5
                                        )
                                        .foregroundColor(isRecording ? .red : .accentColor)
                                        .font(.system(size: 50, weight: .medium, design: .default))
                                        .frame(width: 180, height: 180)
                                        .padding(.bottom, 30)
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
                                        Text("Say this to me..")
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 18))
                                            .padding(.bottom, 5)
                                        
                                        Text(speechPrompt)
                                            .font(.system(size: 38))
                                            .fontWeight(.bold)
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
                                        Spacer()
                                    }
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
        }
        .preferredColorScheme(.dark)
    }
    
    func startSession() {
        sessionStatus = .ongoing
        isStartButtonPulsing = false
        isSpeechButtonPulsing = false
    }
}


struct GameDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        GameDashboardView()
    }
}
