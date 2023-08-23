//
//  InGameView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 23/08/23.
//

import SwiftUI

struct InGameView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var pointsInSession: Int
    
    @State private var navigateToResult = false
    @State private var isBackToDashboard = false
    
    var isStreakYetToday: Bool
    
    var body: some View {
        TabView {
            InGameFirstView(pointsInSession: $pointsInSession, navigateToResult: $navigateToResult, isBackToDashboard: $isBackToDashboard)
            InGameSecondView(pointsInSession: $pointsInSession, navigateToResult: $navigateToResult, isBackToDashboard: $isBackToDashboard)
        }
        .tabViewStyle(PageTabViewStyle())
        .onChange(of: isBackToDashboard){newValue in
            if newValue == true{
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationDestination(isPresented: $navigateToResult){
//            let streakAdded = !isStreakYetToday && pointsInSession > 0 ? 1 : 0
            GameResultView(streak: 0, points: pointsInSession)
                .onDisappear{
                    isBackToDashboard = true
                }
        }
    }
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        InGameView(pointsInSession: .constant(0), isStreakYetToday: false)
    }
}
