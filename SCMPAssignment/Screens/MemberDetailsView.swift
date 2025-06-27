//
//  MemberDetailsView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberDetailsView: View {
    @State private var memberName: String = "John Doe"
    @State private var memberID: String = "M001"
    @State private var email: String = "john.doe@example.com"
    @State private var phoneNumber: String = "+1 (555) 123-4567"
    @State private var membershipType: String = "Premium"
    @State private var joinDate: String = "January 15, 2024"
    @State private var status: String = "Active"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 15) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(String(memberName.prefix(2)).uppercased())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(spacing: 5) {
                            Text(memberName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Member ID: \(memberID)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)
                    
 
                    .padding(.horizontal, 20)
                    
                    // Member Details Section
                    VStack(spacing: 15) {
                        Text("Member Details")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            DetailRow(title: "Email", value: email, icon: "envelope")
                            DetailRow(title: "Phone", value: phoneNumber, icon: "phone")
                            DetailRow(title: "Membership Type", value: membershipType, icon: "star")
                            DetailRow(title: "Join Date", value: joinDate, icon: "calendar")
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        
                        Button(action: {
                            // Handle contact support action
                            print("Contact support tapped")
                        }) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                Text("Contact Support")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Member Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    MemberDetailsView()
} 
