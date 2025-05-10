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
        var summa = 0.0
        var date: Date = Date()
        var selectedDate: Date?
        var selected = ChartRange.week
        var transactions: [Transaction] = []
        var filtered: [Transaction] = []
        var chartsData: [Transaction] = []
        var isLoading = false
        var path = StackState<Destination.State>()
        @Presents var sheet: Destination.State?
    }
    
    enum Action: BindableAction {
        case showDetail(_ transaction: Transaction)
        case fetchdData
        case processResponse([Transaction])
        case filterResponse([Transaction])
        case showTransactionsSheet
        case updateStatus([Transaction])
        case updateSheet([Transaction])
        case path(StackAction<Destination.State, Destination.Action>)
        case sheet(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.csvClient) var csvClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .fetchdData:
                state.isLoading = true
                return .run { send in
                    do {
                        let models = try await csvClient.loadTransactions("data")
                        await send(.processResponse(models))
                    } catch {
                        await send(.processResponse(Transaction.mocks))
                    }
                }
            case let .processResponse(transactions):
                state.transactions = transactions
                state.isLoading = false
                let filtered = filterTransactions(transactions, by: state.selected)
                return .run { send in
                    await send(.filterResponse(filtered))
                    await send(.showTransactionsSheet)
                }
            case let .filterResponse(transactions):
                state.chartsData = transactions
                state.filtered = transactions
                return .send(.updateStatus(transactions))
            case .binding(\.selectedDate):
                let filtered = filterTransactions(state.transactions, by: state.selected, focusDate: state.selectedDate)
                return .run { send in
                    await send(.updateStatus(filtered))
                    await send(.updateSheet(filtered))
                }
            case let .updateStatus(filtered):
                state.summa = filtered.reduce(0) { $0 + $1.amount }
                state.date = filtered.first?.date ?? Date()
                return .none
            case .binding(\.selected):
                let filtered = filterTransactions(state.transactions, by: state.selected)
                return .run { send in
                    await send(.filterResponse(filtered))
                    await send(.updateSheet(filtered))
                }
            case let .updateSheet(filtered):
                if case var .transactionsSheet(sheetState) = state.sheet {
                    sheetState.transactions = filtered
                    state.sheet = .transactionsSheet(sheetState)
                }
                return .none
            case let .showDetail(transaction):
                state.path.append(.detail(DetailReducer.State(transaction: transaction)))
                return .none
            case .showTransactionsSheet:
                state.sheet = .transactionsSheet(TransactionsSheetReducer.State(transactions: state.filtered))
                return .none
            case .path(.popFrom):
                state.path.removeAll()
                return .send(.showTransactionsSheet)
            case let .sheet(.presented(.transactionsSheet(.transactionTapped(transaction)))):
                state.sheet = nil
                return .send(.showDetail(transaction))
            default:
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
    
    func filterTransactions(_ transactions: [Transaction], by range: ChartRange, focusDate: Date? = nil) -> [Transaction] {
        guard !transactions.isEmpty else { return [] }

        let calendar = Calendar.current

        if let focusDate {
            return transactions.filter { calendar.isDate($0.date, inSameDayAs: focusDate) }
        }

        let dates = transactions.map(\.date)
        guard let first = dates.min(), let last = dates.max() else { return [] }

        let (start, end): (Date, Date) = {
            switch range {
            case .week:
                let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: last)) ?? last
                return (start, last)
            case .month:
                let interval = calendar.dateInterval(of: .month, for: last)
                return (interval?.start ?? last, interval?.end ?? last)
            case .year:
                let start = calendar.date(from: DateComponents(year: calendar.component(.year, from: first), month: 1, day: 1)) ?? first
                let end = calendar.date(from: DateComponents(year: calendar.component(.year, from: last), month: 12, day: 31)) ?? last
                return (start, end)
            }
        }()

        return transactions.filter { $0.date >= start && $0.date <= end }
    }
}
