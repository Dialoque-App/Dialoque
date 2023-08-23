//
//  InGameSecondView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 23/08/23.
//

import SwiftUI

struct InGameSecondView: View {
    
    @Binding var pointsInSession: Int
    @Binding var navigateToResult: Bool
    @Binding var isBackToDashboard: Bool
    
    init(pointsInSession: Binding<Int>, navigateToResult: Binding<Bool>, isBackToDashboard: Binding<Bool>) {
        self._pointsInSession = pointsInSession
        self._navigateToResult = navigateToResult
        self._isBackToDashboard = isBackToDashboard
    }
    
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
                        isBackToDashboard = true
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
        InGameSecondView(pointsInSession: .constant(0), navigateToResult: .constant(false), isBackToDashboard: .constant(false))
    }
}
