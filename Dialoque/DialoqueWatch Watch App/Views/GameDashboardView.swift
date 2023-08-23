//
//  GameDashboardView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 21/08/23.
//

import SwiftUI

struct GameDashboardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isSessionStarted = false
    @State private var isSessionOngoing = false
    
    // Provides Binding for pulse animations
    @State private var isStartButtonPulsing = false
    @State private var isSpeechButtonPulsing = false
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    @AppStorage("points", store: UserDefaults.group) var points = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading){
                    Color(red: 28/255, green: 28/255, blue: 30/255)
                    PlayerPointsPanel(streak: $streak, points: $points)
                        .padding(.top, geometry.size.height*0.04)
                        .padding(.leading, geometry.size.height*0.1)
                    
                    ZStack(alignment: .top) {
                        Image("flying_land")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: geometry.size.height*1)
                            .padding(.top, geometry.size.height * 0.8)
                            .clipped()
                        Image("character_no_hand")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:  geometry.size.height * 0.95)
                            .padding(.top, geometry.size.height * 0.24)
                            .clipped()
                        
                            SessionButton (
                                title: "START PRACTICE",
                                foregroundColor: .white,
                                backgroundColor: .accentColor,
                                strokeColor: .darkGreen,
                                horizontalPadding: 14,
                                verticalPadding: 8
                            )
                            .padding(.horizontal, geometry.size.width*0.08)
                            .overlay{
                                HStack{
                                    Image("tangan_depan")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height:  geometry.size.height * 0.26)
                                        .clipped()
                                    Spacer()
                                    Image("tangan_depan")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height:  geometry.size.height * 0.26)
                                        .clipped()
                                        .rotationEffect(.degrees(180))
                                }
                            }
                            .onTapGesture {
                                isSessionStarted = !isSessionStarted
                            }
                            .navigationDestination(isPresented: $isSessionStarted){
                                InGameView()
                            }
                            .padding(.top, geometry.size.height * 0.7)
                        
                    }
                }
                .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

struct GameDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        GameDashboardView()
    }
}
