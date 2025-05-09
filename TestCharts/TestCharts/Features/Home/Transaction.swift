//
//  Transaction.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation

struct Transaction: Codable, Identifiable, Equatable {
    let id: Int
    let date: Date
    let account_name: String
    let description: String
    let amount: Double
}

extension Transaction {
    
    var formattedAmount: String {
        return amount.formatted(
            .currency(code: "USD")
            .presentation(.narrow)
            .precision(.fractionLength(0))
            .locale(.init(identifier: "en_US"))
        )
    }
}

extension Transaction {
    
    static var mocks: [Transaction] = [
        Transaction(id: 1, date: Date(), account_name: "Account_1", description: "Description for Account_1", amount: 876),
        Transaction(id: 2, date: Date(), account_name: "Account_2", description: "Description for Account_2", amount: 123),
        Transaction(id: 3, date: Date(), account_name: "Account_3", description: "Description for Account_3", amount: 456),
        Transaction(id: 4, date: Date(), account_name: "Account_4", description: "Description for Account_4", amount: 789)
    ]
}
