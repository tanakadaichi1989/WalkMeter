//
//  ContentView.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/16.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @EnvironmentObject var viewModel: WalkDataViewModel
    
    var body: some View {
        let todayCount = self.viewModel.dataSource.last?.count ?? 0
        let todayDate = self.viewModel.dataSource.last?.datetime ?? Date()
        
        let userDefaults = UserDefaults(suiteName: "group.Sample.WalkMeter")!
        
        VStack {
            VStack {
                Spacer()
                Text("userDefaults: \(userDefaults.double(forKey: "walkData"))")
                VStack {
                    Text("\(Int(todayCount))")
                        .font(.largeTitle)
                    Text("Walk Count")
                        .font(.title)
                    Text("\(todayDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Divider()
                List {
                    if viewModel.dataSource.count == 0 {
                        Text("歩数データがありません")
                    } else {
                        ForEach(self.viewModel.dataSource){ data in
                            WalkCountView(label: String.showDate(data.datetime), walkCount: Int(data.count))
                        }
                        .onAppear {
                            self.prepareForWidget()
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            self.prepareForWidget()
        }
        .onDisappear {
            self.prepareForWidget()
        }
    }
    
    private func prepareForWidget(){
        self.viewModel.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
