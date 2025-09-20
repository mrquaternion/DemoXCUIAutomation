//
//  ContentView.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-09.
//

import SwiftUI

struct MainView: View {
    private let requiredEmail = "user@example.com"
    private let requiredPassword = "Bitsound123"
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var goNext = false
    
    // Inline errors
    @State private var emailError: String = ""
    @State private var passwordError: String = ""
    
    @State private var animatedText: String = ""
    let text: String = "Relax to your favourite game \n soundtracks"
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Header
                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        SymbolRow()
                        Text("BitSound")
                            .font(.system(size: 40, weight: .light))
                            .monospaced()
                            .foregroundStyle(Color(.darkGray))
                    }
                    .frame(width: 200)
                    
                    Text(animatedText)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .kerning(1)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: 40)
                        .task { await animateText() }
                }
                
                Spacer()
            }
            .safeAreaInset(edge: .bottom) {
                // Auth panel
                VStack(spacing: 36) {
                    VStack(spacing: 14) {
                        InputCard(kind: .email,
                                  title: "Your Email",
                                  text: $email,
                                  error: emailError)
                        
                        InputCard(kind: .password,
                                  title: "Your Password",
                                  text: $password,
                                  error: passwordError)
                        
                        LogInButton(
                            title: "Continue",
                            systemImage: "arrow.right",
                            action: attemptContinue
                        )
                    }
                    
                    Text("Forgot Password?")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.indigo.gradient)
                        .kerning(1)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
                .background(.clear)
            }
            .navigationDestination(isPresented: $goNext) {
                HomeView()
            }
            .onChange(of: email) { _, _ in emailError = "" }
            .onChange(of: password) { _, _ in passwordError = "" }
            .onChange(of: goNext) { _, _ in
                email = ""
                password = ""
                animatedText = ""
            }
        }
    }
    
    // MARK: - Logic
    
    private func attemptContinue() {
        emailError = ""
        passwordError = ""

        if !isValidEmail(email) {
            emailError = AuthError.invalidEmail.message
        }
        else if email != requiredEmail {
            emailError = AuthError.emailNotFound.message
        }
        
        if password != requiredPassword {
            passwordError = AuthError.passwordNotFound.message
        }

        if emailError.isEmpty && passwordError.isEmpty {
            goNext = true
        }
    }
    
    private func isValidEmail(_ s: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return s.range(of: pattern, options: .regularExpression) != nil
    }
    
    private func animateText() async {
        for char in text {
            animatedText.append(char)
            try! await Task.sleep(for: .milliseconds(75))
        }
    }
}

#Preview { MainView() }
