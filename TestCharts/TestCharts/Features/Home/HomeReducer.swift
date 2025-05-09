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
        @Presents var sheet: Destination.State?
    }
    
    enum Action {
        case showDetail(_ transaction: Transaction)
        case fetchdData
        case processResponse([Transaction])
        case path(StackAction<Destination.State, Destination.Action>)
        case sheet(PresentationAction<Destination.Action>)
        case showTransactionsSheet
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.csvClient) var csvClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .showDetail(transaction):
                state.path.append(.detail(DetailReducer.State(transaction: transaction)))
                return .none
            case .fetchdData:
                state.isLoading = true
                state.transactions = Transaction.mocks
                return loadTransactions(from: "data")
            case let .processResponse(transactions):
                state.transactions = transactions
                state.isLoading = false
                return .run { send in
                    await send(.showTransactionsSheet)
                }
            case .showTransactionsSheet:
                state.sheet = .transactionsSheet(TransactionsSheetReducer.State(transactions: state.transactions))
                return .none
            case .path(.element(id: _, action: let action)):
                switch action {
                case .detail(.back):
                    state.path.removeLast()
                    return .none
                default:
                    return .none
                }
            case .path(.popFrom):
                state.path.removeAll()
                return .none
            case .path, .sheet:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$sheet, action: \.sheet)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case detail(DetailReducer)
        case transactionsSheet(TransactionsSheetReducer)
    }
    
    func loadTransactions(from fileName: String) -> Effect<Action> {
        .run { send in
            do {
                let models = try await csvClient.loadTransactions(fileName)
                await send(.processResponse(models))
            } catch {
                await send(.processResponse(Transaction.mocks))
            }
        }
    }
}
