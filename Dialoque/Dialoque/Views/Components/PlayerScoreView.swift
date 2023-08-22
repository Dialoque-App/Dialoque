//
//  PlayerScoreView.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-23.
//

import SwiftUI

struct PlayerScoreView: View {
    @State var score: String
    
    var body: some View {
        Text(score)
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
    }
}
