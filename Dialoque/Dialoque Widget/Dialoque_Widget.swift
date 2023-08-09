//
//  Dialoque_Widget.swift
//  Dialoque Widget
//
//  Created by Jevin Laudo on 2023-08-09.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> DialoqueDataEntry {
        DialoqueDataEntry(
            date: Date(),
            streak: 5,
            points: 39
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DialoqueDataEntry) -> Void) {
        let entry = DialoqueDataEntry(
            date: Date(),
            streak: 5,
            points: 39
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DialoqueDataEntry>) -> Void) {

        let streak = UserDefaults.group?.integer(forKey: "streak") ?? 0

        let points = UserDefaults.group?.integer(forKey: "points") ?? 0

        let entry = DialoqueDataEntry(
            date: Date(),
            streak: streak,
            points: points
        )
        print("Streak: \(streak), Points: \(points)")

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct DialoqueDataEntry: TimelineEntry {
    var date: Date
    var streak: Int
    var points: Int
}

struct Dialoque_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Learning Progress")
                .font(.headline)
            Text("Streak: \(entry.streak)")
            Text("Points: \(entry.points)")
        }
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
        .description("Track the streak and points in Dialoque.")
    }
}

struct Dialoque_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Dialoque_WidgetEntryView(
            entry:
                DialoqueDataEntry(
                    date: Date(),
                    streak: 5,
                    points: 39
                )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
