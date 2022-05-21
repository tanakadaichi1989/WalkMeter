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
    func get(fromDate: Date, toDate: Date, onSuccess: @escaping ([WalkData]) -> Void) {
        var data:[WalkData] = [WalkData]()
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
            
            let query = HKSampleQuery(
                sampleType: HKSampleType.quantityType(forIdentifier: .stepCount)!,
                predicate: HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: []),
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]) { query, results, error in
                    guard error == nil else { return }
                    
                    if let tmpResults = results as? [HKQuantitySample] {
                        for item in tmpResults {
                            data.append(WalkData(id: item.uuid,datetime: item.endDate,count: item.quantity.doubleValue(for: .count())))
                        }
                    }
                    onSuccess(data)
                }
            healthStore.execute(query)
        })
    }
}
