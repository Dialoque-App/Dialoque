//
//  GameKitController.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 02/08/23.
//

import Foundation
import GameKit
import SwiftUI

class GameKitController: NSObject, GKLocalPlayerListener, ObservableObject {
    @ObservedObject var playerModel = PlayerModel.shared
    @ObservedObject var statModel = StatModel.shared
    
//    let LEADERBOARD_ID = "com.nielio.Dialoque.score"
    let LEADERBOARD_ID = "score"
    let ACHIEVEMENT_ID_LUCKY_CLOVER = "com.nielio.Dialoque.achievement.luckyClover"
    
    override init() {
        super.init()

        authenticateUser { [self] success in
            if success {
                self.reportScore(totalScore: statModel.totalScore!)
            }
        }
    }

    func authenticateUser(completion: @escaping (Bool) -> Void) {
        playerModel.localPlayer.authenticateHandler = { [self] _, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                completion(false)
                return
            }

            // Turn off Game Kit Active Indicator
            GKAccessPoint.shared.isActive = false

            if playerModel.localPlayer.isAuthenticated {
                playerModel.localPlayer.register(self)
                completion(true)
            }
        }
    }

    func reportScore(totalScore: Int) {
        if playerModel.localPlayer.isAuthenticated {
            GKLeaderboard.submitScore(
                totalScore,
                context: 0,
                player: playerModel.localPlayer,
                leaderboardIDs: [LEADERBOARD_ID]
            ) { error in
                print("Leaderboard Submit Score Error:")
                if let errorText = error?.localizedDescription {
                    print(errorText)
                }
            }
            print("Score submitted: \(totalScore)")
        }
    }
    
    func reportAchievement(identifier: String){
        if playerModel.localPlayer.isAuthenticated{
            let achievement = GKAchievement(identifier: identifier)
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            
            GKAchievement.report([achievement]) { error in
                if let error = error {
                    print("Failed to report achievement: \(error.localizedDescription)")
                } else {
                    print("Achievement reported successfully!")
                }
            }
        }
    }
}
