//
//  ContentViewModel.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/21.
//

import Foundation
import SwiftUI
import HealthKit
import WidgetKit

class WalkDataViewModel: ObservableObject,Identifiable {
    @Published var dataSource: [WalkData] = [WalkData]()
    @AppStorage("walkData") var walkData = Data()
    
    private let service = WalkDataService()
    let fromDate: Date?
    let toDate: Date?
    
    init(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let year = Calendar.current.component(.year, from: Date()) - 1
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        
        fromDate = dateFormatter.date(from: "\(year)/\(month)/\(day) 00:00:00")
        toDate = Date()
    
        self.service.get(from: fromDate,to: toDate){ data in
            DispatchQueue.main.async {
                self.dataSource = data
                self.save(walkData: data.last)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    private func save(walkData: WalkData?) {
        guard let walkData = walkData else { return }
        guard let unwrappedWalkData = try? JSONEncoder().encode(walkData) else { return }
        print("🍏 JSONEncode: \(unwrappedWalkData.description)")
        self.walkData = unwrappedWalkData
        print("🍎 AppStrorage Recorded.")
    }
}
