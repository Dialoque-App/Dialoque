//
//  PulsingBackgroundShape.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-23.
//

import SwiftUI

extension View {
    func pulsingBackgroundShape<S: Shape>(
        color: Color,
        shape: S,
        isPulsing: Binding<Bool>,
        maxXScale: CGFloat = 1.2,
        maxYScale: CGFloat = 1.2,
        animationDuration: Double = 1.5
    ) -> some View {
        return self.background(
            shape
                .scaleEffect(x: isPulsing.wrappedValue ? maxXScale : 1.0, y: isPulsing.wrappedValue ? maxYScale : 1.0)
                .opacity(isPulsing.wrappedValue ? 0 : 1)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: animationDuration)
                            .repeatForever(autoreverses: false)
                    ) {
                        isPulsing.wrappedValue.toggle()
                    }
                }
        )
    }
}
