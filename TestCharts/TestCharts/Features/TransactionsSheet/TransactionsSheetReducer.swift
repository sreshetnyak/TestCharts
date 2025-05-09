//
//  TransactionsSheetReducer.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TransactionsSheetReducer {
    @ObservableState
    struct State: Equatable {
        var transactions: [Transaction]
    }

    enum Action {
        case dismiss
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
}
