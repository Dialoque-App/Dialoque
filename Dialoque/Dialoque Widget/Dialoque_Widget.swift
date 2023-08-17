//
//  Dialoque_Widget.swift
//  Dialoque Widget
//
//  Created by Jevin Laudo on 2023-08-09.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> DialoqueDataEntry {
        DialoqueDataEntry(
            date: Date(),
            streak: 5,
            isTodayStreakYet: true
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DialoqueDataEntry) -> Void) {
        let entry = DialoqueDataEntry(
            date: Date(),
            streak: 5,
            isTodayStreakYet: true
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DialoqueDataEntry>) -> Void) {
        
        let isTodayStreakYet = UserDefaults.group?.bool(forKey: "isTodayStreakYet") ?? false
        
        let streak = UserDefaults.group?.integer(forKey: "streak") ?? 0
        
        let entry = DialoqueDataEntry(
            date: Date(),
            streak: streak,
            isTodayStreakYet: isTodayStreakYet
        )

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct DialoqueDataEntry: TimelineEntry {
    var date: Date
    var streak: Int
    var isTodayStreakYet: Bool
}

struct Dialoque_WidgetEntryView : View {
    var entry: Provider.Entry

    var characterImage: String
    
    init(entry: Provider.Entry) {
        self.entry = entry
        if !entry.isTodayStreakYet {
            self.characterImage = "character_sleep"
        }
        else if entry.streak > 30 {
            self.characterImage = "character_uniform"
        }
        else {
            self.characterImage = "character_normal"
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 3) {
                GeometryReader { geometry in
                    HStack {
                        Spacer()
                        Image("streak_icon")
                            .resizable()
                            .scaledToFit()
                            .grayscale(entry.isTodayStreakYet ? 0 : 1)
                    }
                    .frame(maxHeight: geometry.size.height)
                }
                Text(String(entry.streak))
                    .font(.title3)
                    .fontWeight(.bold)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.trailing, 20)
            .padding(.top, 20)
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background {
            Image(characterImage)
                .resizable()
                .scaledToFit()
                .padding(.top, 10)
                .padding(.trailing, 10)
        }
        .background(
            Color(red: 28/255, green: 28/255, blue: 30/255)
        )
    }
}

struct Dialoque_Widget: Widget {
    let kind: String = "Dialoque Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            Dialoque_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dialoque")
        .description("Track your daily streaks in Dialoque.")
    }
}

struct Dialoque_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Dialoque_WidgetEntryView(
            entry:
                DialoqueDataEntry(
                    date: Date(),
                    streak: 35,
                    isTodayStreakYet: true
                )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
