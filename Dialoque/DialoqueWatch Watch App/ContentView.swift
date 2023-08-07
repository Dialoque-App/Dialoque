//
//  ContentView.swift
//  Test Watch App
//
//  Created by Jevin Laudo on 2023-08-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject var counter = Counter()
    
    
    var labelStyle: some LabelStyle {
        #if os(watchOS)
            return IconOnlyLabelStyle()
        #else
            return DefaultLabelStyle()
        #endif
    }
    
    var body: some View {
        VStack {
            Text("\(counter.score)")
                .font(.largeTitle)
            
            HStack {
                Button(action: counter.decrement) {
                    Label("Decrement", systemImage: "minus.circle")
                }
                .padding()
                
                Button(action: counter.increment) {
                    Label("Increment", systemImage: "plus.circle.fill")
                }
                .padding()
            }
            .font(.headline)
            .labelStyle(labelStyle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
