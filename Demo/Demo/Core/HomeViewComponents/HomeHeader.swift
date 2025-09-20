//
//  AddButton.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import SwiftUI

struct HomeHeader: View {
    @Binding var showSoundtracks: Bool
    
    var body: some View {
        HStack {
            Text("my soundtracks".capitalized)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Button {
                showSoundtracks = true
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .symbolVariant(.circle.fill)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.indigo, .white)
                    .shadow(color: Color.black.opacity(0.15), radius: 6)
            }
            .accessibilityLabel("add_soundtrack")
        }
    }
}

#Preview {
    HomeHeader(showSoundtracks: .constant(true))
}
