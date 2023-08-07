//
//  Counter.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 04/08/23.
//

import Foundation
import Combine
import WatchConnectivity

final public class Counter: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Int, Never>()
    
    @Published private(set) var score: Int = 0
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$score)
    }
    
    func increment() {
        score += 1
        session.sendMessage(["score": score], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
        print(score)
    }
    
    func decrement() {
        if score <= 0{
            score = 0
        } else {
            score -= 1
        }
        session.sendMessage(["score": score], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
        print(score)
    }
}
