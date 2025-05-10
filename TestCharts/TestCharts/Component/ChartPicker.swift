//
//  SegmentedPicker.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 10.05.2025.
//

import SwiftUI

enum ChartRange: String, CaseIterable, Equatable {
    case week, month, year
}

struct ChartPicker: View {
    
    @Binding var selected: ChartRange
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ChartRange.allCases, id: \.self) { value in
                Button {
                    selected = value
                } label: {
                    Text(value.rawValue.capitalized)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .fill(selected == value ? .white.opacity(0.3) : Color.clear)
                        )
                }
            }
        }
        .padding(.horizontal)
    }
}
