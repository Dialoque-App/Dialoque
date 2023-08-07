//
//  PlayerModel.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 02/08/23.
//

import Foundation
import GameKit
import SwiftUI

struct Player {
    public let id: String
    public let displayName: String
    public let photo: Image?
    public let leaderboard: Leaderboard

    public struct Leaderboard {
        public let rank: Int
        public let score: Int // Input total score
    }
}

class PlayerModel: ObservableObject {
    @Published var localPlayer = GKLocalPlayer.local

    // Create as a Singleton to avoid more than one instance.
    public static var shared: PlayerModel = .init()

    private(set) lazy var isAuthenticated: Bool = localPlayer.isAuthenticated
}
