//
//  ContentView.swift
//  NotifyManually
//
//  Created by Takuya Yokoyama on 2020/02/03.
//  Copyright © 2020 Takuya Yokoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel1 = ViewModel1()
    @ObservedObject var viewModel2 = ViewModel2()
    
    var body: some View {
        VStack {
            Text(viewModel1.title)
            Text(viewModel2.title)
            Button(action: {
                self.viewModel1.onTapButton()
                self.viewModel2.onTapButton()
            }) {
                Text("Button")
            }
        }
    }
}

// Publishedを利用するパターン
class ViewModel1: ObservableObject {
    @Published private(set) var title: String = "Hello, World!"
    
    func onTapButton() {
        self.title = "Hello, Published!"
    }
}

// Publishedを利用しないパターン
import Combine
class ViewModel2: ObservableObject {
    // ObservableObjectプロトコルで宣言されているobjectWillChangeを実装する
    var objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()
    
    private(set) var title: String = "Hello, World!" {
        willSet {
            // データの更新が発生するタイミングでイベントを発生させる
            self.objectWillChange.send()
        }
    }
    
    func onTapButton() {
        self.title = "Hello, ObservableObjectPublisher!"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
