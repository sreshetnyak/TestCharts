//
//  RootReducer.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootReducer {
    
    @ObservableState
    struct State: Equatable {
        var splash = SplashReducer.State()
        var home = HomeReducer.State()
        var isShowSplash = false
    }
    
    enum Action {
        case login(SplashReducer.Action)
        case home(HomeReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .login(\.showHome):
                state.isShowSplash = true
                return .none
            case .home:
                return .none
            default: return .none
            }
        }
        
        Scope(state: \.splash, action: \.login) {
            SplashReducer()
        }
        
        Scope(state: \.home, action: \.home) {
            HomeReducer()
        }
    }
}
