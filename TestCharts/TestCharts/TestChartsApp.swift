//
//  TestChartsApp.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TestChartsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: RootReducer.State(), reducer: {
                RootReducer()
            }))
        }
    }
}
