//
//  MemberListScreen.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberListScreen: View {
    @EnvironmentObject var memberViewModel: MemberViewModel
    @State private var selectedMember: MemberDetails?
    @Binding var isLoggedIn: Bool
    
    var token: String? {
        KeychainHelper.shared.read(forKey: "userToken")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Show token at the top
                if let token = token {
                    Text("Token: \(token)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                if memberViewModel.isLoading && memberViewModel.members.isEmpty {
                    // Loading state
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                        Text("Loading members...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = memberViewModel.errorMessage {
                    // Error state
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Button("Retry") {
                            memberViewModel.fetchMembers()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Success state - List of members with lazy loading
                    List {
                        ForEach(memberViewModel.members) { member in
                            Button {
                                selectedMember = member
                            } label: {
                                VStack(spacing: 0) {
                                    MemberRowView(member: member)
                                    Divider()
                                }
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .onAppear {
                                memberViewModel.loadMoreIfNeeded(currentMember: member)
                            }
                        }
                        if memberViewModel.isLoading && !memberViewModel.members.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        memberViewModel.refreshMembers()
                    }
                }
            }
            .onAppear {
                if memberViewModel.members.isEmpty {
                    memberViewModel.fetchMembers()
                }
            }
            .navigationDestination(item: $selectedMember) { member in
                MemberDetailsView(member: member)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        KeychainHelper.shared.delete(forKey: "userToken")
                        isLoggedIn = false
                    }
                }
            }
        }
    }
}


#Preview {
    MemberListScreen(isLoggedIn: .constant(true))
        .environmentObject(MemberViewModel())
}
