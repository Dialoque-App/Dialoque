//
//  ScoreView.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 07/08/23.
//

import SwiftUI

struct ScoreView: View {
    
    @EnvironmentObject private var scoreModel: ScoreModel
//    @State private var errorWrapper: ErrorWrapper?
//    let scores: [ScoreItem]
    
    var body: some View {
        VStack{
            Button{
                Task {
                    do {
                        try await scoreModel.addScore(score: ScoreItem(point: 10, dateAssigned: .now))
                        try await scoreModel.populateScores()
                        
                    } catch {
                        print("Error adding + fetching")
                        print(error)
                    }
                }
            } label: {
                Text("populate")
            }
        }
         
            
        
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
