//
//  GameResultView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 22/08/23.
//

import SwiftUI

struct GameResultView: View {
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading){
                    Color(red: 28/255, green: 28/255, blue: 30/255)
                    
                    VStack(alignment: .center){
                        Text("CONGRATULATIONS")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(Color.white)
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

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView()
    }
}
