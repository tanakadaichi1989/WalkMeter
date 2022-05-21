//
//  ContentView.swift
//  WalkMeter
//
//  Created by 田中大地 on 2022/05/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WalkDataViewModel
    
    var body: some View {
        List {
            if viewModel.dataSource.count == 0 {
                Text("データがありません")
            } else {
                ForEach( viewModel.dataSource ){ item in
                    HStack {
                        Text(item.datetime.description)
                        Text("\(item.count)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
