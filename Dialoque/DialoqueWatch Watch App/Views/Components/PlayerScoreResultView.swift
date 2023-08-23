//
//  PlayerScoreResultView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 23/08/23.
//

import SwiftUI

struct PlayerScoreResultView: View {
    
    @State var streak: Int
    @State var points: Int
    
    var body: some View {
        VStack(spacing: 8){
            HStack{
                Image("streak_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .clipped()
                Text("+\(streak) Streak")
                    .font(.system(size: 10))
                    .bold()
                    .foregroundColor(Color.white)
            }
            HStack{
                Image("coin_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .clipped()
                Text("+\(points) Points")
                    .font(.system(size: 10))
                    .bold()
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct PlayerScoreResultView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreResultView(streak: 1, points: 8)
    }
}
