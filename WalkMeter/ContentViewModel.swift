//
//  ContentViewModel.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/21.
//

import Foundation
import SwiftUI
import HealthKit

class ContentViewModel: ObservableObject,Identifiable {
    @Published var dataSource: [WalkData] = [WalkData]()
}
