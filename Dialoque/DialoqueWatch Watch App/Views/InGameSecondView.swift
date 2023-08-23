//
//  InGameSecondView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 23/08/23.
//

import SwiftUI

struct InGameSecondView: View {
    
    @State private var isSessionEnded = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top){
                    Color(red: 28/255, green: 28/255, blue: 30/255)
                    Image("flying_land")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:  geometry.size.height * 0.65)
                        .padding(.top, geometry.size.height * 0.84)
                        .clipped()
                    Image("character_holding_end_practice")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:  geometry.size.height * 0.55)
                        .padding(.top, geometry.size.height * 0.52)
                        .clipped()
                    SessionButton (
                        title: "END PRACTICE",
                        foregroundColor: .white,
                        backgroundColor: .lightRed,
                        strokeColor: .darkRed,
                        horizontalPadding: 16,
                        verticalPadding: 8
                    )
                    .onTapGesture {
                        isSessionEnded = !isSessionEnded
                    }
                    .navigationDestination(isPresented: $isSessionEnded){
                        GameResultView()
                    }
                    .padding(.top, geometry.size.height*0.4)
                    
                }
                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        
    }
}

struct InGameSecondView_Previews: PreviewProvider {
    static var previews: some View {
        InGameSecondView()
    }
}
