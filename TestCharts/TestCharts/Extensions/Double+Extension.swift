//
//  Double+Extension.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 10.05.2025.
//

import Foundation

extension Double {
    
    func currencyParts(locale: Locale = .init(identifier: "en_US"), currencyCode: String = "USD") -> (sign: String, symbol: String, main: String, decimal: String) {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        guard let formatted = formatter.string(from: NSNumber(value: abs(self))) else {
            return ("", "$", "\(Int(self))", "00")
        }
        
        let symbol = formatter.currencySymbol ?? "$"
        let sign = self < 0 ? "−" : ""
        let decimalSeparator = formatter.decimalSeparator ?? "."
        
        let raw = formatted.replacingOccurrences(of: symbol, with: "").trimmingCharacters(in: .whitespaces)
        
        if let separatorRange = raw.range(of: decimalSeparator) {
            let main = String(raw[..<separatorRange.lowerBound])
            let decimal = String(raw[separatorRange.upperBound...])
            return (sign, symbol, main, decimal)
        } else {
            return (sign, symbol, raw, "00")
        }
    }
}
