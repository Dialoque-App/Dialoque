//
//  SessionButton.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-23.
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
            .fontWeight(.bold)
            .bold()
            .foregroundColor(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(strokeColor, lineWidth: 6)
            )
    }
}
