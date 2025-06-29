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
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var hasFetched: Bool = false
    @State private var didInitialAppear: Bool = false
    
    var token: String? {
        KeychainHelper.shared.read(forKey: "userToken")
    }
    
    var body: some View {
        NavigationStack {
            if !networkMonitor.didReceiveFirstStatus {
                // Show a full-screen loading spinner while waiting for network status
                VStack {
                    Spacer()
                    ProgressView("Loading")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            } else {
                VStack(spacing: 0) {
                    // Show token at the top
                    if let token = token {
                        Text("Token: \(token)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                    // Show offline banner if not connected
                    if !networkMonitor.isConnected && !memberViewModel.isActuallyOnline {
                        Text("You are offline. Showing cached data.")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
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
                    } else if let errorMessage = memberViewModel.errorMessage, memberViewModel.members.isEmpty {
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
                                        MemberRowView(member: member, refreshID: memberViewModel.refreshID)
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
                .overlay(
                    // Progress overlay for pull-to-refresh
                    Group {
                        if memberViewModel.isRefreshing {
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.2)
                                Text("Refreshing...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 4)
                        }
                    }
                )
                .navigationDestination(item: $selectedMember) { member in
                    MemberDetailsView(member: member)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            KeychainHelper.shared.delete(forKey: "userToken")
                            UserDefaultsHelper.shared.clearMemberList()
                            isLoggedIn = false
                        }
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
