//
//  FadeSlidingTransition.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-20.
//

import SwiftUI

extension AnyTransition {
    static func slideAndFade(
        direction: SlideDirection = .leading,
        offset: CGFloat = 50,
        opacity: Double = 1.0
    ) -> AnyTransition {
        let xOffset: CGFloat
        let yOffset: CGFloat
        
        let isSlidingAnimation: Bool = false
        
        switch direction {
            case .top:
                xOffset = 0
                yOffset = isSlidingAnimation ? 0 : -offset
            case .bottom:
                xOffset = 0
                yOffset = isSlidingAnimation ? 0 : offset
            case .leading:
                xOffset = isSlidingAnimation ? 0 : -offset
                yOffset = 0
            case .trailing:
                xOffset = isSlidingAnimation ? 0 : offset
                yOffset = 0
        }
        
        let insertion = AnyTransition.offset(x: xOffset, y: yOffset)
            .combined(with: .opacity)
        
        let removal = AnyTransition.offset(x: xOffset, y: yOffset)
            .combined(with: .opacity)
        
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
