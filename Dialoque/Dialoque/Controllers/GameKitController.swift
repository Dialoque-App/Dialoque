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
    @StateObject private var pointsCountManager: PointsCountManager

    override init() {
        let pointsCountManager = PointsCountManager(context: PersistenceController.shared.container.viewContext)
        _pointsCountManager = StateObject(wrappedValue: pointsCountManager)
        
        super.init()
        
        authenticateUser { [self] success in
            if success {
                self.reportStreak(streak: pointsCountManager.pointsCount)
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

    func reportStreak(streak: Int) {
        if playerModel.localPlayer.isAuthenticated {
            GKLeaderboard.submitScore(
                streak,
                context: 0,
                player: playerModel.localPlayer,
                leaderboardIDs: [LeaderboardID.streak]
            ) { error in
                print("Leaderboard Submit Score Error:")
                if let errorText = error?.localizedDescription {
                    print(errorText)
                }
            }
            print("Score submitted: \(streak)")
        }
    }
    
    func reportAchievement(achievementID: String){
        if playerModel.localPlayer.isAuthenticated{
            let achievement = GKAchievement(identifier: achievementID)
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
