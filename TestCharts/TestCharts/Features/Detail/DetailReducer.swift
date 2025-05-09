//
//  DetailReducer.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailReducer {
    
    @ObservableState
    struct State: Equatable {
        var transaction: Transaction
    }
    
    enum Action: Equatable {
        case back
    }
    
    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .back:
                return .none
            }
        }
    }
}
