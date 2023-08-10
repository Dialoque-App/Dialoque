//
//  ContentView.swift
//  Test Watch App
//
//  Created by Jevin Laudo on 2023-08-02.
//

import SwiftUI

struct DashboardView: View {
    var labelStyle: some LabelStyle {
        #if os(watchOS)
            return IconOnlyLabelStyle()
        #else
            return DefaultLabelStyle()
        #endif
    }
    
    var body: some View {
        VStack {
            Text("hello")
                .font(.largeTitle)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
