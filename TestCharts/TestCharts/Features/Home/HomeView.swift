//
//  HomeView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct HomeView: View {
    
    @Bindable var store: StoreOf<HomeReducer>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Statistics")
                            .foregroundColor(.white)
                    }
                }
        } destination: { state in
            switch state.case {
            case .detail(let store):
                DetailView(store: store)
            default:
                EmptyView()
            }
        }
        .sheet(
            item: $store.scope(state: \.sheet, action: \.sheet)
        ) { sheetStore in
            switch sheetStore.case {
            case .transactionsSheet(let transactionsStore):
                TransactionsSheetView(store: transactionsStore)
            default:
                EmptyView()
            }
        }
        .task {
            store.send(.fetchdData)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack {
            Color.bg
                .ignoresSafeArea(.all)
            
            VStack(spacing: 24) {
                VStack {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(store.summa.currencyParts().sign)
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 48, weight: .medium))
                        
                        Text(store.summa.currencyParts().symbol)
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 48, weight: .medium))
                        
                        Text(store.summa.currencyParts().main)
                            .foregroundColor(.white)
                            .font(.system(size: 48, weight: .bold))
                        
                        Text(".")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                        
                        Text(store.summa.currencyParts().decimal)
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .animation(.default, value: store.summa)
                    
                    Text(store.date.formatted(date: .complete, time: .omitted))
                        .animation(.default, value: store.date)
                }
                .foregroundStyle(.white)
                .redacted(reason: store.isLoading ? .placeholder : .invalidated)
                
                ChartView(
                    chartsData: $store.chartsData,
                    selectedDate: $store.selectedDate
                )
                .redacted(reason: store.isLoading ? .placeholder : .invalidated)
                .frame(height: 340)
                
                ChartPicker(
                    selected: $store.selected
                ).redacted(reason: store.isLoading ? .placeholder : .invalidated)
                
            }.frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
