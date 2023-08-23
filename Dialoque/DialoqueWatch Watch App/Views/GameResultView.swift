//
//  GameResultView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 22/08/23.
//

import SwiftUI

struct GameResultView: View {
    
    @State private var isSessionEnded = false
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    @AppStorage("points", store: UserDefaults.group) var points = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top){
                    Color(red: 28/255, green: 28/255, blue: 30/255)
                    VStack{
                        Text("CONGRATULATIONS")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("You've got")
                            .font(.system(size: 14))
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(.bottom)
                        PlayerScoreResultView(streak: streak, points: points)
                        Spacer()
                        SessionButton (
                            title: "DONE",
                            foregroundColor: .white,
                            backgroundColor: .accentColor,
                            strokeColor: .darkGreen,
                            horizontalPadding: 12,
                            verticalPadding: 4
                        )
                        .onTapGesture {
                            isSessionEnded = !isSessionEnded
                        }
                        .navigationDestination(isPresented: $isSessionEnded){
                            GameDashboardView()
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.size.height*0.3)
                    
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

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView()
    }
}
