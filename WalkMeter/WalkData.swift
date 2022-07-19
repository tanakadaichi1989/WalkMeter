//
//  WalkData.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/21.
//

import Foundation
import SwiftUI

struct WalkData: Identifiable,Codable {
    var id: UUID
    var datetime: Date
    var count: Double
}
