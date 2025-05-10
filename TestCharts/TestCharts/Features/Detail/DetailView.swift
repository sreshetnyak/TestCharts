//
//  DetailView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var store: StoreOf<DetailReducer>
    
    var body: some View {
        VStack(spacing: 24) {
            AvatarView(
                username: store.transaction.account_name,
                size: 80
            )
            
            VStack(spacing: 4) {
                Text(store.transaction.account_name)
                    .font(.system(size: 24, weight: .medium))
                Text(store.transaction.description)
                    .font(.system(size: 16, weight: .light))
                    .foregroundStyle(.foreground)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(store.transaction.amount.currencyParts().sign)
                    .font(.system(size: 40, weight: .regular))
                
                Text(store.transaction.amount.currencyParts().symbol)
                    .font(.system(size: 40, weight: .regular))
                
                Text(store.transaction.amount.currencyParts().main)
                    .font(.system(size: 40, weight: .regular))
                
                Text(".")
                    .font(.system(size: 22, weight: .regular))
                
                Text(store.transaction.amount.currencyParts().decimal)
                    .font(.system(size: 22, weight: .regular))
            }
        }
        .padding(.top, 24)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                        .tint(.black)
                })
            }
            ToolbarItem(placement: .principal) {
                Text("Details")
                    .foregroundColor(.black)
            }
        }
    }
}
