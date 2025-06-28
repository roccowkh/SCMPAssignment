//
//  MemberViewModel.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import Foundation
import SwiftUI

@MainActor
class MemberViewModel: ObservableObject {
    @Published var members: [MemberDetails] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 0
    @Published var totalMembers: Int = 0
    
    private let baseURL = "https://reqres.in/api/users"
    
    // MARK: - Public Methods
    
    func fetchMembers(page: Int = 1) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "\(baseURL)?page=\(page)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let response = try JSONDecoder().decode(MemberDetailsResponse.self, from: data)
            
            await MainActor.run {
                self.members = response.data
                self.currentPage = response.page
                self.totalPages = response.totalPages
                self.totalMembers = response.total
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch members: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func loadNextPage() async {
        guard currentPage < totalPages else { return }
        await fetchMembers(page: currentPage + 1)
    }
    
    func refreshMembers() async {
        await fetchMembers(page: 1)
    }
    
    func getMember(by id: Int) -> MemberDetails? {
        return members.first { $0.id == id }
    }
    
    // MARK: - Search and Filter Methods
    
    func searchMembers(query: String) -> [MemberDetails] {
        guard !query.isEmpty else { return members }
        
        return members.filter { member in
            member.fullName.localizedCaseInsensitiveContains(query) ||
            member.email.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Error Handling
    
    func clearError() {
        errorMessage = nil
    }
}
