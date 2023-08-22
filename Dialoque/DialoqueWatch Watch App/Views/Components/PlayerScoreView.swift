//
//  PlayerScoreView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 22/08/23.
//

import SwiftUI

struct PlayerScoreView: View {
    @State var score: String
    
    var body: some View {
        Text(score)
            .foregroundColor(.black)
            .font(.system(size: 12))
            .lineLimit(1)
            .truncationMode(.tail)
            .bold()
            .padding(.leading, 8)
            .padding(.trailing, 18)
            .frame(minWidth: 42, alignment: .center)
            .padding(.vertical, 2)
            .background(.white)
            .cornerRadius(16)
    }
}

struct PlayerScoreView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreView(score: String(999))
    }
}
