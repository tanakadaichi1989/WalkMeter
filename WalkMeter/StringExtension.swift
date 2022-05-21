//
//  StringExtension.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/22.
//

import Foundation

extension String {
    static func showDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
}
