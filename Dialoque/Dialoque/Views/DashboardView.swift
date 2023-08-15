//
//  DashboardView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 14/08/23.
//

import SwiftUI

struct DashboardView: View {
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
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(
                                Image("character_default")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: geometry.size.height*0.35)
                                    .clipped()
                            )
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
                            Image("leaderboard_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: geometry.size.height*0.08)
                                .clipped()
                            Spacer()
                            Image("achievement_icon_white")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: geometry.size.height*0.08)
                                .clipped()
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        Button{
                            print("Start Practice Button Tapped")
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

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
