//
//  Dex3Widget.swift
//  Dex3Widget
//
//  Created by Raja Adeel Ahmed on 4/8/23.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    var randomPokemon : Pokemon {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        var results:[Pokemon] = []
        
        do {
            results = try context.fetch(fetchRequest)
        } catch {
            print("\(error) ")
        }
        
        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        
        return SamplePokemon.samplePokemon
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let pokemon : Pokemon
}

struct Dex3WidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
        case .systemSmall:
            WidgetPokemon(widgetSize: .small)
                .environmentObject(entry.pokemon)
        
        case .systemLarge:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        case .systemMedium:
            WidgetPokemon(widgetSize: .medium)
                .environmentObject(entry.pokemon)
        default:
            WidgetPokemon(widgetSize: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

struct Dex3Widget: Widget {
    let kind: String = "Dex3Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Dex3WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Dex3Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Dex3WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            Dex3WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            Dex3WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), pokemon: SamplePokemon.samplePokemon))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
