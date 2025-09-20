//
//  LogInButton.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import SwiftUI

struct LogInButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button { action() } label: {
            HStack {
                Text(title).monospaced()
                Spacer()
                Image(systemName: systemImage)
            }
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 30)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.indigo.gradient.opacity(0.8))
                    .shadow(color: .black.opacity(0.5), radius: 7, x: 0, y: 4)
            )
            .padding(.horizontal, 30)
        }
        .accessibilityLabel("login")
    }
}

#Preview {
    LogInButton(title: "Continue", systemImage: "arrow.right", action: { })
}
