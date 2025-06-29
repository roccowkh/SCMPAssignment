//
//  LoginView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Binding var isLoggedIn: Bool
    @State private var isErrorSnackBarVisible: Bool = false
    @EnvironmentObject private var memberViewModel: MemberViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                            
                            TextField("Enter your email", text: $viewModel.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .disabled(viewModel.isLoading)
                            
                            // Always reserve space for the error message
                            Text(viewModel.emailError ?? " ")
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
                                if viewModel.isPasswordVisible {
                                    TextField("Enter your password", text: $viewModel.password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .disabled(viewModel.isLoading)
                                } else {
                                    SecureField("Enter your password", text: $viewModel.password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .disabled(viewModel.isLoading)
                                }
                                
                                Button(action: {
                                    viewModel.isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.secondary)
                                }
                                .disabled(viewModel.isLoading)
                            }
                            // Always reserve space for the error message
                            Text(viewModel.passwordError ?? " ")
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(height: 16, alignment: .top)
                        }
                    }
                    .padding(.horizontal, 30)
                                        
                    // Login Button
                    Button(action: {
                        viewModel.login { success in
                            if success {
                                memberViewModel.initialFetchIfNeeded()
                                isLoggedIn = true
                            } else if viewModel.errorMessage != nil {
                                isErrorSnackBarVisible = true
                            }
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(viewModel.isLoading ? "Signing In..." : "Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .disabled(!viewModel.canSignIn)
                    .opacity(viewModel.canSignIn ? 1.0 : 0.6)
                }
                .padding(.bottom, 40)
                
                // ErrorSnackBar overlay
                
                VStack {
                    Spacer()
                    ErrorSnackBar(message: viewModel.errorMessage ?? "", isVisible: $isErrorSnackBarVisible)
                        .padding()
                }
                .animation(.easeInOut, value: isErrorSnackBarVisible)
                
                // Loading overlay
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        )
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
