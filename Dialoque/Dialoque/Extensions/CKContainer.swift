//
//  CKContainer.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 07/08/23.
//

import Foundation
import CloudKit

extension CKContainer {
    
    var isUserLoggedIn: Bool {
        get async throws {
            let accountStatus = try await self.accountStatus()
            switch accountStatus {
                case .couldNotDetermine, .restricted, .noAccount, .temporarilyUnavailable:
                    return false
                case .available:
                    return true
                @unknown default:
                    return false
            }
        }
    }
    
}
