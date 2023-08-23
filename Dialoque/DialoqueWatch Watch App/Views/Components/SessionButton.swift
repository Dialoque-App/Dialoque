//
//  SessionButton.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 22/08/23.
//

import SwiftUI

struct SessionButton: View {
    let title: String
    let foregroundColor: Color
    let backgroundColor: Color
    let strokeColor: Color
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    
    var body: some View {
        Text(title)
            .font(.system(size: 11))
            .bold()
            .foregroundColor(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(strokeColor, lineWidth: 4)
            )
    }
}
