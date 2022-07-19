//
//  WalkMeterWidget.swift
//  WalkMeterWidget
//
//  Created by 田中大地 on 2022/07/19.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), walkData: WalkData(id: UUID(), datetime: Date(), count: Double(0)))
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), walkData: WalkData(id: UUID(), datetime: Date(), count: Double(9999)))
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.Sample.WalkMeter")!
        let currentDate = Date()
        let walkData = userDefaults.object(forKey: "walkData")
        
        let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        
        guard let unwrappedWalkData = try? JSONDecoder().decode(WalkData.self, from: walkData as! Data) else {
            let entry = SimpleEntry(date: entryDate, walkData: WalkData(id: UUID(), datetime: Date(), count: Double(0)))
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
            return
        }
        
        let entry = SimpleEntry(date: entryDate, walkData: unwrappedWalkData)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    //let configuration: ConfigurationIntent
    let walkData: WalkData
}

struct WalkMeterWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("\(Int(entry.walkData.count))")
            Text(entry.date.description)
        }
    }
}

@main
struct WalkMeterWidget: Widget {
    let kind: String = "WalkMeterWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WalkMeterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WalkMeterWidget_Previews: PreviewProvider {
    static var previews: some View {
        WalkMeterWidgetEntryView(entry: SimpleEntry(date: Date(), walkData: WalkData(id: UUID(), datetime: Date(), count: Double(1234))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
