//
//  ErrorWrapper.swift
//  Dialoque
//
//  Created by Daniel Aprillio on 07/08/23.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
}
