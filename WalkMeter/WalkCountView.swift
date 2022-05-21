//
//  WalkCountView.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/21.
//

import SwiftUI

struct WalkCountView: View {
    var label: String
    var walkCount: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
            Text(walkCount.description)
                .fontWeight(.heavy)
        }
    }
}

struct WalkCountView_Previews: PreviewProvider {
    static var previews: some View {
        WalkCountView(label: "今日の歩数", walkCount: 10000)
    }
}
