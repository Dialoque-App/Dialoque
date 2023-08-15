//
//  InGameView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 15/08/23.
//

import SwiftUI

struct InGameView: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ZStack(alignment: .top){
                    Color.black
                    Group{
                        ZStack(alignment: .bottom){
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(
                                    Image("flying_land")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: geometry.size.height*0.30)
                                        .clipped()
                                )
                                .padding(.top, geometry.size.height*0.25)
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                                .frame(height: geometry.size.height*0.4)
                                .padding(.bottom, geometry.size.height*0.2)
                        }
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(
                                Image("character_default")
                                    .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: geometry.size.height*0.25)
                                        .clipped()
                                )
                                .padding(.bottom, geometry.size.height*0.08)
                    }
                    VStack{
                        Group{
                            ZStack{
                                RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 36)
                                    .fill(Color.darkGray).frame(height: geometry.size.height*0.2)
                                HStack(alignment: .bottom ,spacing: geometry.size.width*0.045){
                                    Button{
                                        print("Start Practice Button Tapped")
                                    } label: {
                                        Text("END PRACTICE")
                                            .font(.system(size: 18))
                                            .bold()
                                            .foregroundColor(.white)
                                            .frame(width: geometry.size.width*0.45)
                                            .padding()
                                            .background(RoundedRectangle(cornerRadius: 25).fill(Color.lightRed.shadow(.drop(color: .black, radius: 12))))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.darkRed, lineWidth: 8)
                                            )
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
                                .padding(.top, geometry.size.height*0.025)
                            }
                        }
                        HStack(alignment: .center, spacing: 2){
                            ForEach(1...3, id:\.self){ _ in
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 32))
                                    .clipped()
                            }
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        Group{
                            Text("Say this to me..")
                                .foregroundColor(Color.white)
                                .frame(width: geometry.size.width*0.8 ,alignment: .leading)
                            Text("HAPPY")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width*0.72)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.shadow(.drop(color: .black, radius: 12))))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .padding(.bottom, geometry.size.height*0.05)
                            Rectangle() //recording button here
                                .fill(Color.red)
                                .frame(width: 72, height: 72)
                                .padding(.bottom, geometry.size.height*0.05)
                        }
                        .padding(.horizontal, geometry.size.width*0.075)
                        
                    }
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        InGameView()
    }
}
