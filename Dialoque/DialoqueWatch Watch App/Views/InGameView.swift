//
//  InGameView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 23/08/23.
//

import SwiftUI

struct InGameView: View {
    var body: some View {
        TabView {
            InGameFirstView()
            InGameSecondView()
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        InGameView()
    }
}
