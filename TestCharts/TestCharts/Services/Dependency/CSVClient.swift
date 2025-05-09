//
//  Dependency.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct CSVClient {
    var loadTransactions: (String) async throws -> [Transaction]
}

extension DependencyValues {
    var csvClient: CSVClient {
        get { self[CSVClient.self] }
        set { self[CSVClient.self] = newValue }
    }
}

extension CSVClient: DependencyKey {
    static let liveValue: CSVClient = CSVClient(
        loadTransactions: { fileName in
            let provider = CSVProvider()
            return try await provider.loadTransactions(fileName: fileName)
        }
    )

    static let testValue: CSVClient = CSVClient(
        loadTransactions: { _ in
            return Transaction.mocks
        }
    )
}
