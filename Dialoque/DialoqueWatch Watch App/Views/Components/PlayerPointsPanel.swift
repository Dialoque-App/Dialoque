//
//  PlayerPointsPanel.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 21/08/23.
//

import SwiftUI

struct PlayerPointsPanel: View {
    
    @Binding var streak: Int
    @Binding var points: Int
    
    var body: some View {
        HStack(alignment: .top ,spacing: 2){
            PlayerScoreView(score: String(streak))
                .padding(.vertical, 4)
                .padding(.trailing, 8)
                .overlay(
                    Image("streak_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26)
                        .clipped()
                        .padding(.leading)
                    ,alignment: .trailing
                )
                .transition(.slideAndFade())
            PlayerScoreView(score: String(points))
                .padding(.vertical, 4)
                .padding(.trailing, 8)
                .overlay(
                    Image("coin_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26)
                        .clipped()
                        .padding(.leading)
                    ,alignment: .trailing
                )
                .transition(.slideAndFade())
        }
        .animation(.easeOut(duration: 0.5))
    }
    
}

struct PlayerPointsPanel_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPointsPanel(
            streak: .constant(27),
            points: .constant(54)
        )
    }
}
