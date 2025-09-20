//
//  InputCard.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-10.
//

import SwiftUI

struct InputCard: View {
    enum Kind { case email, password }
    let kind: Kind
    let title: String
    @Binding var text: String
    var error: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                if kind == .password {
                    Group {
                        if isSecure {
                            SecureField(title, text: $text)
                                .textContentType(.password)
                                .accessibilityLabel("your_password")
                        } else {
                            TextField(title, text: $text)
                                .textContentType(.password)
                                .accessibilityLabel("your_password")
                        }
                    }
                    
                    Button(action: { isSecure.toggle() }) {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(.gray)
                    }
                    .accessibilityLabel(isSecure ? "show_password" : "hide_password")
                } else {
                    TextField(title, text: $text)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("your_email")
                }
            }
            .font(.system(size: 20, weight: .bold))
            .monospaced()
            .foregroundStyle(.gray)
            .padding(.horizontal, 30)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
            )
            .padding(.horizontal, 30)
            
            // Inline error
           
            Text(error)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.red)
                .padding(.horizontal, 30)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    Spacer()
    InputCard(kind: .email, title: "Your Email", text: .constant(""), error: "")
    InputCard(kind: .email, title: "Your Email", text: .constant("mat@com"), error: "Invalid e-mail.")
    Spacer()
    InputCard(kind: .password, title: "Your Password", text: .constant(""), error: "")
    InputCard(kind: .password, title: "Your Password", text: .constant("welcome"), error: "Invalid password.")
    Spacer()
}
