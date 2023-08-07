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

    let LEADERBOARD_ID = "com.nielio.Dialoque.score"

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
                leaderboardIDs: ["score"]
            ) { error in
                print("Leaderboard Submit Score Error:")
                print(error)
            }
            print("Score submitted: \(totalScore)")
        }
    }
}
