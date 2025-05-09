//
//  CSVProvider.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import Foundation

enum CSVProviderError: Error {
    case fileNotFound
}

final class CSVProvider {
    
    private let dateFormatter: DateFormatter
    
    private let bundle: Bundle = .main
    
    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func loadTransactions(fileName: String) async throws -> [Transaction] {
        guard let url = bundle.url(forResource: fileName, withExtension: "csv") else {
            throw CSVProviderError.fileNotFound
        }
        let content = try await read(from: url)
        return parseCSV(content)
    }
    
    private func read(from url: URL) async throws -> String {
        let content = try await Task.detached {
            try String(contentsOf: url, encoding: .utf8)
        }.value
        
        return content
    }
    
    private func parseCSV(_ csv: String) -> [Transaction] {
        csv.components(separatedBy: .newlines)
            .dropFirst()
            .compactMap { line in
                let columns = line.split(separator: ",", omittingEmptySubsequences: false).map { String($0) }
                guard columns.count == 5,
                      let id = Int(columns[0]),
                      let date = dateFormatter.date(from: columns[1]),
                      let amount = Double(columns[4]) else {
                    return nil
                }
                
                return Transaction(
                    id: id,
                    date: date,
                    account_name: columns[2],
                    description: columns[3],
                    amount: amount
                )
            }
    }
}
