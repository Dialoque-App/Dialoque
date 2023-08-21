//
//  PlayerScoreView.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-23.
//

import SwiftUI

struct PlayerScoreView: View {
    @Binding var score: Int
    @State var displayedScore: Int
    
    init(score: Binding<Int>) {
        self._score = score
        self.displayedScore = score.wrappedValue
    }
    
    var body: some View {
        Text(String(displayedScore))
            .foregroundColor(.black)
            .font(.title2)
            .lineLimit(1)
            .truncationMode(.tail)
            .bold()
            .padding(.trailing, 20)
            .frame(minWidth: 65, alignment: .center)
            .padding(.leading, 13)
            .padding(.vertical, 2)
            .background(.white)
            .cornerRadius(16)
            .onChange(of: score) { newScore in
                withAnimation {
                    if newScore > displayedScore {
                        let scoreChangeRange = displayedScore...newScore
                        for scoreValue in scoreChangeRange {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(scoreValue - displayedScore) * 0.05) {
                                displayedScore = scoreValue
                            }
                        }
                    } else {
                        displayedScore = newScore
                    }
                }
            }
    }
}
