//
//  SplashView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    
    @State var store: StoreOf<SplashReducer>
    
    var body: some View {
        content
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
            Text("Welcome to Chart Test")
        }
    }
}
