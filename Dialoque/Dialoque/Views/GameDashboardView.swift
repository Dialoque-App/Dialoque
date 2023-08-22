//
//  GameDashboardView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 14/08/23.
//

import SwiftUI

struct GameDashboardView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var gameKitController: GameKitController
    
    @State var isPressed = false
    @State var isGameCenterPresented = false
    
    @State private var isStartButtonPulsing = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack{
                    HStack(alignment: .bottom) {
                        Image("american_flag")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                            .frame(height: 40)
                            .clipped()
                            .padding(.trailing, 8)
                        Spacer()
                        PlayerScoreView(score: "27")
                            .padding(.trailing, 20)
                            .padding(.top, 14)
                            .padding(.bottom, 6)
                            .overlay(
                                Image("streak_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                ,alignment: .trailing
                            )
                            .padding(.leading, 10)
                        Spacer()
                        PlayerScoreView(score: "54")
                            .padding(.trailing, 30)
                            .padding(.top, 14)
                            .padding(.bottom, 6)
                            .overlay(
                                Image("coin_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                ,alignment: .trailing
                            )
                    }
                    .padding(.vertical, geometry.size.height * 0.03)
                    .padding(.horizontal, geometry.size.width * 0.06)
                    .frame(height: geometry.size.height * 0.17, alignment: .bottom)
                    .background(Color.darkGray)
                    .clipShape(
                        RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 36)
                    )
                    ZStack(alignment: .top){
                        VStack {
                            HStack {
                                Image("leaderboard_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                    .onTapGesture {
                                        isGameCenterPresented = true
                                    }
                                    .fullScreenCover(isPresented: $isGameCenterPresented) {
                                        GameCenterView().ignoresSafeArea()
                                    }
                                
                                Spacer()
                                
                                Image("achievement_icon_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipped()
                                    .onTapGesture {
                                        isGameCenterPresented = true
                                    }
                                    .fullScreenCover(isPresented: $isGameCenterPresented) {
                                        GameCenterView().ignoresSafeArea()
                                    }
                            }
                            .frame(height: 65)
                            .padding(.top, 25)
                            .padding(.horizontal, 30)
                            Spacer()
                            NavigationLink(destination: InGameView()) {
                                SessionButton (
                                    title: "START PRACTICE",
                                    foregroundColor: .white,
                                    backgroundColor: .accentColor,
                                    strokeColor: .darkGreen
                                )
                                .pulsingBackgroundShape (
                                    color: .accentColor,
                                    shape: Capsule(),
                                    isPulsing: $isStartButtonPulsing,
                                    maxXScale: 1.2,
                                    maxYScale: 1.5
                                )
                            }
                            .navigationBarBackButtonHidden(true)
                            .padding(.bottom, geometry.size.height * 0.15)
                        }
                        .zIndex(2)
                        ZStack(alignment: .center) {
                            Image("flying_land")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, geometry.size.height * 0.3)
                            
                            Button{
                                isPressed = !isPressed
                            } label: {
                                if(isPressed) {
                                    LottieView(lottieFile: "dialoque_character_mini_jump", loopMode: .loop)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: geometry.size.height * 0.415)
                                        .clipped()
                                        .padding(.bottom, geometry.size.height * 0.12)
                                } else {
                                    Image("character_default")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height:  geometry.size.height * 0.3)
                                        .clipped()
                                }
                            }
                            .padding(.bottom, geometry.size.height * 0.08)
                        }
                        .scaleEffect(1.1)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: geometry.size.height * 0.7
                        )
                        .zIndex(1)
                    }
                }
            }
            .ignoresSafeArea()
            .background(Color(UIColor.systemGray6))
        }
        .preferredColorScheme(.dark)
    }
}

struct GameDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        GameDashboardView()
    }
}
