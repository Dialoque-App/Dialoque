//
//  ScoreModel.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 07/08/23.
//

import Foundation
import CloudKit
import SwiftUI

enum ScoreError: Error {
    case operationFailed(Error)
}

enum UserAccountError: Error {
    case notSignedIn
}

@MainActor
class ScoreModel: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published private var scoreDictionary: [CKRecord.ID: ScoreItem] = [:]
    
    var score: [ScoreItem] {
        scoreDictionary.values.compactMap { $0 }
    }
    
    func checkUserLoginToiCloud() async throws -> Bool {
        try await CKContainer.default().isUserLoggedIn
    }
    
    func populateScores() async throws {

        let query = CKQuery(recordType: ScoreRecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }

        records.forEach { record in
            scoreDictionary[record.recordID] = ScoreItem(record: record)
        }
        
        print(scoreDictionary)
    }
    
    func addScore(score: ScoreItem) async throws {
        let record = try await db.save(score.record)
        guard let score = ScoreItem(record: record) else { return }
        
        scoreDictionary[score.recordId!] = score
    }
    
//    func deleteScore(ScoreToBeDeleted: ScoreItem) async throws {
//
//        scoreDictionary.removeValue(forKey: ScoreToBeDeleted.recordId!)
//
//        do {
//            let _ = try await db.deleteRecord(withID: ScoreToBeDeleted.recordId!)
//        } catch {
//            // put back the task into the tasks array
//            scoreDictionary[ScoreToBeDeleted.recordId!] = taskToBeDeleted
//            // throw the exception
//            throw ScoreError.operationFailed(error)
//        }
//    }
    
}
