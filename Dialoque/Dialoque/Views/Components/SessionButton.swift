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
    
    var body: some View {
        Text(title)
            .font(.system(size: 26))
            .fontWeight(.bold)
            .bold()
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(backgroundColor)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(strokeColor, lineWidth: 8)
            )
    }
}
