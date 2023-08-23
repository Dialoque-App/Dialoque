//
//  Identifiers.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 21/08/23.
//

import Foundation


struct LeaderboardID{
    static let streak = "com.nielio.Dialoque.leaderboard.streak"
}

struct AchievementID{
    // Complete first session
    static let firstStep = "com.nielio.Dialoque.achievement.firstStep"
    
    // All answers are wrong in 1 session
    static let wrongWay = "com.nielio.Dialoque.achievement.wrongWay"
    
    // Answers ... words correctly in a row
    static let correct10 = "com.nielio.Dialoque.achievement.correct10"
    
    // Collect ... coins in total
    static let point25 = "com.nielio.Dialoque.achievement.point25"
    static let point50 = "com.nielio.Dialoque.achievement.point50"
    static let point100 = "com.nielio.Dialoque.achievement.point100"
    
    // Active for ... days
    static let dayStreak3 = "com.nielio.Dialoque.achievement.dayStreak3"
    static let dayStreak7 = "com.nielio.Dialoque.achievement.dayStreak7"
    static let dayStreak14 = "com.nielio.Dialoque.achievement.dayStreak14"
    static let dayStreak30 = "com.nielio.Dialoque.achievement.dayStreak30"
    static let dayStreak90 = "com.nielio.Dialoque.achievement.dayStreak90"
    static let dayStreak180 = "com.nielio.Dialoque.achievement.dayStreak180"
    static let dayStreak365 = "com.nielio.Dialoque.achievement.dayStreak365"
}
