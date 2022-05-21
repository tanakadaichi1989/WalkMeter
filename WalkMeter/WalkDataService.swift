//
//  WalkDataService.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/21.
//

import Foundation
import SwiftUI
import HealthKit

class WalkDataService {
    func get(from fromDate: Date?, to toDate: Date?, data: @escaping ([WalkData]) -> Void) {
        
        var items:[WalkData] = [WalkData]()
        let healthStore = HKHealthStore()
        let readTypes = Set([
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ])
        
        healthStore.requestAuthorization(toShare: [], read: readTypes, completion: { success, error in
            guard error == nil else { return }
            if !success {
                print("DEBUG: Can't access heath data ...")
                return
            }
            
            guard let fromDate = fromDate else { return }
            guard let toDate = toDate else { return }

            let calendar = Calendar.current

            let interval = DateComponents(day: 1)
 
            let components = DateComponents(
                calendar: calendar,
                timeZone: calendar.timeZone,
                hour: 0,
                minute: 0,
                second: 0,
                weekday: 1
            )

            guard let anchorDate = calendar.nextDate(
                after: Date(),
                matching: components,
                matchingPolicy: .nextTime,
                repeatedTimePolicy: .first,
                direction: .backward
            ) else { fatalError() }
            
            let query = HKStatisticsCollectionQuery(
                quantityType: .quantityType(forIdentifier: .stepCount)!,
                quantitySamplePredicate: nil,
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: interval
            )
            
            query.initialResultsHandler = { query, collection, error in
                guard let statsCollection = collection else { return }
                statsCollection.enumerateStatistics(from: fromDate, to: toDate) { stats, stop in
                    if let quantity = stats.sumQuantity() {
                        let date = stats.startDate
                        let count = quantity.doubleValue(for: .count())
                        print("DEGUB Date: \(date), Count: \(count)")
                        items.append(WalkData(id: UUID(), datetime: date, count: count))
                    }
                }
                data(items)
            }
            healthStore.execute(query)
        })
    }
}
