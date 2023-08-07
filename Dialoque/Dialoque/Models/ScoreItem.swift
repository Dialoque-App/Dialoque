//
//  ScoreModel.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 07/08/23.
//

import Foundation
import CloudKit

enum ScoreRecordKeys: String {
    case type = "ScoreItem"
    case point
    case dateAssigned
}

struct ScoreItem {
    var recordId: CKRecord.ID?
    let point: Int
    let dateAssigned: Date
}

extension ScoreItem {
    init?(record: CKRecord) {
        
        guard let point = record["point"] as? Int,
              let dateAssigned = record["dateAssigned"] as? Date else {
            return nil
        }
        
        self.init(recordId: record.recordID, point: point, dateAssigned: dateAssigned)
    }
}


extension ScoreItem {
    
    var record: CKRecord {
        let record = CKRecord(recordType: ScoreRecordKeys.type.rawValue)
        record["point"] = point
        record["dateAssigned"] = dateAssigned
        return record
    }
}

