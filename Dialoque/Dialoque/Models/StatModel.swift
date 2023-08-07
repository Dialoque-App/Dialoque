//
//  StatModel.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 02/08/23.
//

import Foundation
import SwiftUI

protocol Stat {
    var amount: Int? { get set }
    var maxValue: Int { get set }

    init(maxValue: Int)
}

class StatModel: ObservableObject {
    public static var shared: StatModel = .init()

    @AppStorage("score")
    var score: Int?

    @AppStorage("totalScore")
    var totalScore: Int?
    
    init() {
        if score == nil {
            score = 0
        }

        if totalScore == nil {
            totalScore = 0
        }
    }

    func increaseScore(amount: Int) {
        if score == nil {
            score = 0
        }
        score! += amount
        totalScore! += amount
    }

    func decreaseScore(amount: Int) {
        if score == nil {
            score = 0
        }
        score! -= amount
        score = max(score ?? 0, 0)
    }
}

