//
//  StatController.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 02/08/23.
//

import Foundation
import SwiftUI

class StatController: ObservableObject {
    @ObservedObject var statModel = StatModel.shared

    var score: Int {
        return statModel.score ?? 0
    }

    var totalScore: Int {
        return statModel.totalScore ?? 0
    }
        
    func increaseScore(amount: Int) {
        statModel.increaseScore(amount: amount)
    }

    func decreaseScore(amount: Int) {
        statModel.decreaseScore(amount: amount)
    }
}
