//
//  HomeReducer.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeReducer {
    
    @ObservableState
    struct State: Equatable {
        var transactions: [Transaction] = []
        var isLoading = false
        var path = StackState<Destination.State>()
    }
    
    enum Action {
        case showDetail(_ transaction: Transaction)
        case fetchdData
        case processResponse([Transaction])
        case path(StackAction<Destination.State, Destination.Action>)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .showDetail(transaction):
                state.path.append(.detail(DetailReducer.State(transaction: transaction)))
                return .none
            case .fetchdData:
                state.isLoading = true
                state.transactions = Transaction.mocks
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.processResponse(Transaction.mocks))
                }
            case let .processResponse(transactions):
                state.transactions = transactions
                state.isLoading = false
                return .none
            case .path(.element(id: _, action: let action)):
                switch action {
                case .detail(.back):
                    state.path.removeLast()
                    return .none
                }
            case .path(.popFrom):
                state.path.removeAll()
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case detail(DetailReducer)
    }
}
