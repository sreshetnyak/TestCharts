//
//  TransactionsSheetView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture

struct TransactionsSheetView: View {
    let store: StoreOf<TransactionsSheetReducer>
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Accounts")
                        .font(.system(size: 20))
                        .padding(.vertical)
                        .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    ForEach(store.transactions, id: \.id) { transaction in
                        HStack {
                            AvatarView(username: transaction.account_name, size: 48)
                            VStack(alignment: .leading) {
                                Text(transaction.account_name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text(transaction.description)
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Text(transaction.formattedAmount)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.leading, 70)
                    }
                }
            }
            .interactiveDismissDisabled()
            .presentationDetents([.fraction(0.35), .medium, .fraction(0.95)])
            .presentationBackgroundInteraction(.enabled)
            .presentationContentInteraction(.scrolls)
        }
    }
}
