//
//  LoginView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var navigateToMemberList: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Sign in to your account")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // Input Fields
                VStack(spacing: 20) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .disabled(isLoading)
                            .onChange(of: email) { _, newValue in
                                if newValue.isEmpty || isValidEmail(newValue) {
                                    emailError = nil
                                } else {
                                    emailError = "Please enter a valid email address."
                                }
                            }
                        
                        Text(emailError ?? " ")
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(height: 16, alignment: .top)
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Enter your password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(isLoading)
                                    .onChange(of: password) { _, newValue in
                                        if newValue.isEmpty || isValidPassword(newValue) {
                                            passwordError = nil
                                        } else {
                                            passwordError = "Password must be 6-10 letters or numbers."
                                        }
                                    }
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(isLoading)
                                    .onChange(of: password) { _, newValue in
                                        if newValue.isEmpty || isValidPassword(newValue) {
                                            passwordError = nil
                                        } else {
                                            passwordError = "Password must be 6-10 letters or numbers."
                                        }
                                    }
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.secondary)
                            }
                            .disabled(isLoading)
                        }
                        Text(passwordError ?? " ")
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(height: 16, alignment: .top)
                    }
                }
                .padding(.horizontal, 30)
                
                // Error Message (for login failure)
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                // Login Button
                Button(action: {
                    // Only allow login if email and password are valid
                    guard emailError == nil, passwordError == nil, !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    isLoading = true
                    errorMessage = nil
                    APIManager.shared.login(email: email, password: password) { result in
                        isLoading = false
                        switch result {
                        case .success(let token):
                            print("Login successful! Token: \(token)")
                            navigateToMemberList = true
                        case .failure(let error):
                            print("Login failed: \(error.localizedDescription)")
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(isLoading ? "Signing In..." : "Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .disabled(isLoading || emailError != nil || passwordError != nil || email.isEmpty || password.isEmpty)
                .opacity((isLoading || emailError != nil || passwordError != nil || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                
                Spacer()
            }
            .overlay(
                Group {
                    if isLoading {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                            )
                    }
                }
            )
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToMemberList) {
                MemberListScreen()
            }
        }
    }

    // Email validation function
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // Password validation function
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^[A-Za-z0-9]{6,10}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}

#Preview {
    LoginView()
}
