//
//  InGameFirstView.swift
//  DialoqueWatch Watch App
//
//  Created by Daniel Aprillio on 22/08/23.
//

import SwiftUI

struct InGameFirstView: View {
    
    @State private var currentPage = 0
    
    @State var isSessionEnded = false
    
    @State private var playerHealth = 3
    
    @State private var speechPrompt = "HAPPY"
    @State private var recognizedText = ""
    
    @State private var isRecording = false
    
    // Provides Binding for pulse animations
    @State private var isStartButtonPulsing = false
    @State private var isSpeechButtonPulsing = false
    
    @AppStorage("streak", store: UserDefaults.group) var streak = 0
    @AppStorage("points", store: UserDefaults.group) var points = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading){
                    Color(red: 28/255, green: 28/255, blue: 30/255)
                    PlayerPointsPanel(streak: $streak, points: $points)
                        .padding(.top, geometry.size.height*0.04)
                        .padding(.leading, geometry.size.height*0.1)
                    
                    Image("character_default")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:  geometry.size.height * 0.85)
                        .padding(.top, geometry.size.height * 0.85)
                        .padding(.leading)
                        .rotationEffect(.degrees(30))
                        .clipped()
                    
                    ZStack {
                        VStack(alignment: .leading) {
                            Text("Say this to me..")
                                .bold()
                                .foregroundColor(Color.white)
                                .font(.system(size: 8))
                                .padding(.bottom, 2)
                            
                            Text(speechPrompt)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(5)
                                .background(Color(red: 28/255, green: 28/255, blue: 30/255))
                                .cornerRadius(40)
                                .clipped()
                                .padding(2)
                                .background(.white)
                                .cornerRadius(240)
                                .clipped()
                            
                            HStack(alignment: .center, spacing: 0){
                                Spacer()
                                ForEach(0 ..< playerHealth, id:\.self){ _ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color.red)
                                        .font(.system(size: 12))
                                        .clipped()
                                }
                                ForEach(0 ..< 3 - playerHealth, id:\.self){ _ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color.gray)
                                        .font(.system(size: 12))
                                        .clipped()
                                }
                            }
                            .padding(.top, 2)
                        }
                        .padding(.top, geometry.size.height*0.3)
                        .padding(.horizontal, geometry.size.width*0.05)
                    }
                    Circle()
                        .foregroundColor(.accentColor)
                        .frame(height: geometry.size.height*0.4)
                        .aspectRatio(contentMode: .fit)
                        .overlay{
                            Image(systemName: "mic.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            presentTextInputControllerForLanguage(language: "en-US")
                        }
                        .padding(.leading, geometry.size.width*0.62)
                        .padding(.top, geometry.size.height*0.9)
                }
                .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        
    }
    
    private func presentTextInputControllerForLanguage(language: String) {
        WKExtension.shared().visibleInterfaceController?.presentTextInputControllerWithSuggestions(
            forLanguage: { (inputLanguage) in
                if inputLanguage == language {
                    // Provide suggestions based on the selected language
                    // You can customize this part to return appropriate suggestions
                    return []
                } else {
                    return nil
                }
            },
            allowedInputMode: .plain
        ) { (results) in
            if let input = results?.first as? String {
                self.recognizedText = input
            } else {
                self.recognizedText = "No input"
            }
        }
    }
}

struct InGameFirstView_Previews: PreviewProvider {
    static var previews: some View {
        InGameFirstView()
    }
}
