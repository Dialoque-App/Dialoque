//
//  GameResultView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 15/08/23.
//

import SwiftUI

struct GameResultView: View {
    
    @State private var pointCount = 95
    @State private var streakCount = 1
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack(alignment: .top){
                    Color.black
                    VStack{
                        Group{
                            ZStack{
                                RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 36)
                                    .fill(Color.darkGray).frame(height: geometry.size.height*0.2)
                                VStack(spacing: 8){
                                    Text("CONGRATULATIONS")
                                        .font(.system(size: 24))
                                        .bold()
                                        .foregroundColor(Color.white)
                                    Text("on your fantastic pronunciation practice session!")
                                        .font(.system(size: geometry.size.height > geometry.size.width ? geometry.size.width * 0.036: geometry.size.height * 0.1))
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.top, geometry.size.height*0.025)
                            }
                        }
                        VStack(spacing: geometry.size.height*0.04){
                            Text("You've got")
                                .font(.system(size: 28))
                                .fontWeight(Font.Weight.heavy)
                                .foregroundColor(Color.white)
                                .padding(.bottom)
                            HStack{
                                Image("streak_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, geometry.size.height*0.01)
                                    .frame(height: geometry.size.height*0.065)
                                    .clipped()
                                Text("+\(streakCount) Streak")
                                    .font(.system(size: 24))
                                    .fontWeight(Font.Weight.bold)
                                    .foregroundColor(Color.white)
                            }
                            HStack{
                                Image("coin_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, geometry.size.height*0.01)
                                    .frame(height: geometry.size.height*0.065)
                                    .clipped()
                                Text("+\(pointCount) Coins")
                                    .font(.system(size: 24))
                                    .fontWeight(Font.Weight.bold)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding(.vertical, geometry.size.height*0.08)
                        
                        Text("Keep up the fantastic effort as you continue to refine your pronunciation skills. You're well on your way to pronunciation mastery!")
                            .font(.system(size: geometry.size.height > geometry.size.width ? geometry.size.width * 0.036: geometry.size.height * 0.1))
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width*0.8)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                        
                        Spacer()
                        
                        Button{
                            let gameDashboardView = GameDashboardView()
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: gameDashboardView)
                        } label: {
                            Text("DONE")
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
                        .padding(.bottom, geometry.size.height*0.08)
                    }
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView()
    }
}
