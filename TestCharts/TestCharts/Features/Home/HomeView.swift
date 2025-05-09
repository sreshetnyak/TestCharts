//
//  HomeView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    
    @Bindable var store: StoreOf<HomeReducer>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            content
                .navigationTitle("Home")
        } destination: { state in
            switch state.case {
            case .detail(let store):
                DetailView(store: store)
            }
        }
        .task {
            store.send(.fetchdData)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    ForEach(store.transactions, id: \.id) { transaction in
                        HStack {
                            AvatarView(username: transaction.account_name, size: 40)
                            VStack(alignment: .leading) {
                                Text(transaction.account_name)
                                    .font(.body)
                                Text(transaction.description)
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.cornerRadius(8))
                        .onTapGesture {
                            store.send(.showDetail(transaction))
                        }
                    }
                }
                .redacted(reason: store.isLoading ? .placeholder : .invalidated)
            }

        }
        .padding(.horizontal)
    }
}
