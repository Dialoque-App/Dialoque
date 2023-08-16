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
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack(alignment: .top){
                    Color.black
                    Group{
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(
                                Image("flying_land")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: geometry.size.height*0.40)
                                    .clipped()
                            )
                            .padding(.top, geometry.size.height*0.48)
                        Button{
                            isPressed = !isPressed
                        } label: {
                            if(isPressed){
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(
                                        LottieView(lottieFile: "dialoque_character_mini_jump", loopMode: .loop)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: geometry.size.height*1.8)
                                            .clipped()
                                            .padding(.bottom, geometry.size.height*0.1)
                                    )
                                    .animation(.easeOut)
                            } else {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(
                                        Image("character_default")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: geometry.size.height*0.35)
                                            .clipped()
                                    )
                                    .animation(.easeOut)
                            }
                        }
                        .padding(.top, geometry.size.height*0.05)
                    }
                    VStack{
                        Group{
                            ZStack{
                                RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 36)
                                    .fill(Color.darkGray).frame(height: geometry.size.height*0.2)
                                HStack(alignment: .bottom ,spacing: geometry.size.width*0.045){
                                    Image("american_flag")
                                        .resizable()
                                        .cornerRadius(12)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width*0.25, height: geometry.size.height*0.05)
                                        .clipped()
                                    ZStack(alignment: .bottomTrailing){
                                        RoundedCornersShape(corners: [.allCorners], radius: 16)
                                            .fill(Color.white)
                                            .frame(width: geometry.size.width*0.3, height: geometry.size.height*0.05)
                                        HStack(alignment: .center){
                                            Text("24")
                                                .font(.system(size: 22))
                                                .bold()
                                                .padding(.top, 12)
                                            Image("streak_icon")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(.bottom, geometry.size.height*0.01)
                                                .frame(height: geometry.size.height*0.065)
                                                .clipped()
                                        }
                                    }
                                    ZStack(alignment: .bottomTrailing){
                                        RoundedCornersShape(corners: [.allCorners], radius: 16)
                                            .fill(Color.white)
                                            .frame(width: geometry.size.width*0.3, height: geometry.size.height*0.05)
                                        HStack(alignment: .center){
                                            Text("952")
                                                .font(.system(size: 22))
                                                .bold()
                                                .padding(.top, 12)
                                            Image("coin_icon")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .padding(.bottom, geometry.size.height*0.01)
                                                .frame(height: geometry.size.height*0.065)
                                                .clipped()
                                        }
                                    }
                                }
                                .padding(.top, geometry.size.height*0.02)
                            }
                        }
                        HStack{
                            Spacer().frame(width: geometry.size.width*0.05)
                            Button{
                                isGameCenterPresented = true
                            } label: {
                                Image("leaderboard_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: geometry.size.height*0.08)
                                    .clipped()
                            }.fullScreenCover(isPresented: $isGameCenterPresented) {
                                GameCenterView().ignoresSafeArea()
                            }
                            Spacer()
                            Button{
                                isGameCenterPresented = true
                            } label: {
                                Image("achievement_icon_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: geometry.size.height*0.08)
                                    .clipped()
                            }.fullScreenCover(isPresented: $isGameCenterPresented) {
                                GameCenterView().ignoresSafeArea()
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        Button{
                            let inGameView = InGameView()
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: inGameView)
                        } label: {
                            Text("START PRACTICE")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width*0.5)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25).fill(Color.lightGreen.shadow(.drop(color: .black, radius: 12))))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.darkGreen, lineWidth: 8)
                                )
                        }
                        .padding(.bottom, geometry.size.height*0.15)
                    }
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

struct GameDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        GameDashboardView()
    }
}
