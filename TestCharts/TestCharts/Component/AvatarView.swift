//
//  AvatarView.swift
//  TestCharts
//
//  Created by Sergey Reshetnyak on 09.05.2025.
//

import SwiftUI

struct AvatarView: View {
    
    let username: String
    
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor(for: username))
                .frame(width: size, height: size)

            Text(initials(from: username))
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private func initials(from username: String) -> String {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.contains(" ") {
            return trimmed
                .split(separator: " ")
                .prefix(2)
                .compactMap { $0.first?.uppercased() }
                .joined()
        } else {
            return String(trimmed.prefix(2)).uppercased()
        }
    }

    private func backgroundColor(for username: String) -> Color {
        let hash = username.hash
        let r = Double((hash & 0xFF0000) >> 16) / 255.0
        let g = Double((hash & 0x00FF00) >> 8) / 255.0
        let b = Double(hash & 0x0000FF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}
