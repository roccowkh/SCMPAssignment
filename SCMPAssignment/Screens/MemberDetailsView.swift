//
//  MemberDetailsView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberDetailsView: View {
    @EnvironmentObject var memberViewModel: MemberViewModel
    @State private var selectedMember: MemberDetails?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let member = selectedMember {
                        // Profile Header
                        VStack(spacing: 15) {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text(member.initials)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                )
                            
                            VStack(spacing: 5) {
                                Text(member.fullName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Member ID: \(member.id)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Member Details Section
                        VStack(spacing: 15) {
                            Text("Member Details")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                DetailRow(title: "Email", value: member.email, icon: "envelope")
                                DetailRow(title: "First Name", value: member.firstName, icon: "person")
                                DetailRow(title: "Last Name", value: member.lastName, icon: "person")
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            Button(action: {
                                // Handle edit profile action
                                print("Edit profile tapped for \(member.fullName)")
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Profile")
                                }
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
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
                    } else {
                        // Loading or no member selected
                        VStack(spacing: 20) {
                            if memberViewModel.isLoading {
                                ProgressView("Loading member details...")
                            } else {
                                Text("No member selected")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Member Details")
//            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Load members if not already loaded
                if memberViewModel.members.isEmpty {
                    Task {
                        await memberViewModel.fetchMembers()
                    }
                }
            }
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
        .environmentObject(MemberViewModel())
} 
