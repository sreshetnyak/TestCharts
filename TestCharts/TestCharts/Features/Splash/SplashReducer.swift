//
//  SplashReducer.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SplashReducer {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case onAppear
        case showHome
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.showHome)
                }
            case .showHome:
                return .none
            }
        }
    }
}
