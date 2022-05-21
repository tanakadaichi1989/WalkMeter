//
//  WalkMeterApp.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/16.
//

import SwiftUI
import HealthKit

@main
struct WalkMeterApp: App {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            if HKHealthStore.isHealthDataAvailable() {
                ContentView()
                    .environmentObject(viewModel)
            }
        }
    }
}
