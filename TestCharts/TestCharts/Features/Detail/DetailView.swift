//
//  DetailView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    
    @Bindable var store: StoreOf<DetailReducer>
    
    var body: some View {
        VStack {
            Text("transaction details")
        }
        .navigationTitle("Details")
    }
}
