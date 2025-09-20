//
//  SymbolRow.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import SwiftUI


// MARK: - Symbol Row

struct SymbolRow: View {
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "gamecontroller.fill")
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Spacer()
            Image(systemName: "headphones")
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Spacer()
            Image(systemName: "moon.zzz.fill")
                .foregroundStyle(
                    LinearGradient(
                        colors: [.indigo, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .font(.system(size: 40))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SymbolRow()
}
