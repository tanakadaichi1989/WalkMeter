//
//  ContentViewModel.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/21.
//

import Foundation
import SwiftUI
import HealthKit

class WalkDataViewModel: ObservableObject,Identifiable {
    @Published var dataSource: [WalkData] = [WalkData]()
    private let service = WalkDataService()
    
    init(){
        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        self.service.get(fromDate: dateformatter.date(from: "2020/01/01 00:00:00")!, toDate: dateformatter.date(from: "2022/05/20 23:59:59")!) { data in
            DispatchQueue.main.async {
                self.dataSource = data
            }
        }
    }
    
    func get(fromDate: Date, toDate: Date) {
        self.service.get(fromDate: fromDate, toDate: toDate) { data in
            self.dataSource = data
        }
    }
}
