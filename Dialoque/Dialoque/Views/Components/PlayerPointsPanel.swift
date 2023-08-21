//
//  PlayerPointsPane.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-20.
//

import SwiftUI

struct PlayerPointsPanel: View {
    @Binding var sessionStatus: GameStatus
    @Binding var streak: Int
    @Binding var points: Int
    
    @State var isSlidingAnimation = false
    @State var slidingXOffset = false
    @State var sliding = false
    
    var body: some View {
        HStack(alignment: .bottom) {
            switch sessionStatus {
            case .idle:
                Image("american_flag")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                    .frame(height: 40)
                    .clipped()
                    .transition(.slideAndFade())
                Spacer()
                PlayerScoreView(score: $streak)
                    .padding(.trailing, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 6)
                    .overlay(
                        Image("streak_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                        ,alignment: .trailing
                    )
                    .padding(.leading, 10)
                    .transition(.slideAndFade())
            case .ongoing:
                SessionButton(
                    title: "END PRACTICE",
                    foregroundColor: .white,
                    backgroundColor: .lightRed,
                    strokeColor: .darkRed,
                    horizontalPadding: 26,
                    verticalPadding: 12
                )
                .font(.system(size: 16))
                .transition(.slideAndFade())
                .onTapGesture {
                    endSession()
                }
            }
            Spacer()
            PlayerScoreView(score: $points)
                .padding(.trailing, 30)
                .padding(.top, 14)
                .padding(.bottom, 6)
                .overlay(
                    Image("coin_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                    ,alignment: .trailing
                )
                .transition(.slide)
        }
        .padding(.bottom, 25)
        .padding(.horizontal, 30)
        .frame(height: 130, alignment: .bottom)
        .background(Color.darkGray)
        .clipShape(
            RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 36)
        )
        .animation(.easeOut(duration: 0.5), value: sessionStatus)
    }
    
    func endSession() {
        sessionStatus = .idle
    }
}

struct PlayerPointsPanel_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPointsPanel(
            sessionStatus: .constant(.idle),
            streak: .constant(27),
            points: .constant(54)
        )
    }
}
