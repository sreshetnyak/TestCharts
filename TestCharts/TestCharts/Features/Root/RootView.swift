//
//  RootView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct RootView: View {
    
    @Bindable var store: StoreOf<RootReducer>
    
    var body: some View {
        if store.isShowSplash {
            HomeView(store: store.scope(state: \.home, action: \.home))
        } else {
            SplashView(store: store.scope(state: \.splash, action: \.login))
        }
    }
}
