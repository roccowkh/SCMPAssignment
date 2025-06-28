//
//  LoginView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
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
                    // Username Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .disabled(isLoading)
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
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(isLoading)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.secondary)
                            }
                            .disabled(isLoading)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                // Login Button
                Button(action: {
                    isLoading = true
                    APIManager.shared.login(email: "eve.holt@reqres.in", password: "cityslicka") { result in
                        isLoading = false
                        switch result {
                        case .success(let token):
                            print("Login successful! Token: \(token)")
                            navigateToMemberList = true
                            // You can now save the token or update your app state
                        case .failure(let error):
                            print("Login failed: \(error.localizedDescription)")
                            // Show error to user
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
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1.0)
                
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
}

#Preview {
    LoginView()
}
