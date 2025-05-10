//
//  ChartView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 10.05.2025.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @Binding var chartsData: [Transaction]
    
    @Binding var selectedDate: Date?
    
    private func closest(to date: Date) -> Transaction? {
        chartsData.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) })
    }
    
    private var yRange: ClosedRange<Double> {
        let values = chartsData.map(\.amount)
        guard let min = values.min(), let max = values.max() else {
            return -1_000...1_000
        }
        let padding = (max - min) * 0.15
        return (min - padding)...(max + padding)
    }
    
    var body: some View {
        Chart {
            ForEach(chartsData) { point in
                LineMark(
                    x: .value("date", point.date),
                    y: .value("amount", point.amount)
                )
                .interpolationMethod(.cardinal)
                .foregroundStyle(.green)
                
                AreaMark(
                    x: .value("date", point.date),
                    yStart: .value("zero", yRange.lowerBound),
                    yEnd: .value("amount", point.amount)
                )
                .interpolationMethod(.cardinal)
                .foregroundStyle(
                    .linearGradient(
                        colors: [Color.green.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                RuleMark(
                    x: .value("date", point.date),
                    yStart: .value("start", yRange.lowerBound),
                    yEnd: .value("end", yRange.lowerBound + 40)
                )
                .lineStyle(StrokeStyle(lineWidth: 1))
                .foregroundStyle(.gray)
            }
            
            if let selectedDate = selectedDate,
               let selectedPoint = closest(to: selectedDate) {
                if let firstDataPoint = chartsData.last {
                    RectangleMark(
                        xStart: .value("", firstDataPoint.date),
                        xEnd: .value("", selectedPoint.date)
                    )
                    .foregroundStyle(.black)
                    .opacity(0.4)
                    .accessibilityHidden(true)
                    .mask {
                        ForEach(chartsData, id: \.date) { dataPoint in
                            AreaMark(
                                x: .value("mask_date", dataPoint.date),
                                yStart: .value("mask_zero", yRange.lowerBound),
                                yEnd: .value("mask_amount", dataPoint.amount),
                                series: .value("", "mask"),
                            )
                            .interpolationMethod(.cardinal)
                            
                            LineMark(
                                x: .value("mask_date", dataPoint.date),
                                y: .value("mask_zero", dataPoint.amount),
                                series: .value("", "mask")
                            )
                            .interpolationMethod(.cardinal)
                        }
                    }
                }
                
                RuleMark(
                    x: .value("selected", selectedPoint.date),
                    yStart: .value("bottom", yRange.lowerBound),
                    yEnd: .value("top", selectedPoint.amount)
                )
                .foregroundStyle(.white)
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                PointMark(
                    x: .value("date", selectedPoint.date),
                    y: .value("amount", selectedPoint.amount)
                )
                .symbolSize(80)
                .foregroundStyle(.green)
            }
        }
        .chartYScale(domain: yRange)
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartXSelection(value: $selectedDate)
        .animation(.spring, value: chartsData)
    }
}
