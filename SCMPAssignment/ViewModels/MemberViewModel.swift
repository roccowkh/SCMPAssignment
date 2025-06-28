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
    
    // MARK: - Public Methods
    
    func fetchMembers(page: Int = 1, completion: @escaping () -> Void = {}) {
        isLoading = true
        errorMessage = nil
        
        APIManager.shared.fetchMembers(page: page) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if page == 1 {
                        self.members = response.data
                    } else {
                        // Append new members for subsequent pages
                        let newMembers = response.data.filter { newMember in
                            !self.members.contains(where: { $0.id == newMember.id })
                        }
                        self.members.append(contentsOf: newMembers)
                    }
                    self.currentPage = response.page
                    self.totalPages = response.totalPages
                    self.totalMembers = response.total
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = "Failed to fetch members: \(error.localizedDescription)"
                    self.isLoading = false
                }
                completion()
            }
        }
    }
    
    func loadNextPage(completion: @escaping () -> Void = {}) {
        guard currentPage < totalPages else { return }
        fetchMembers(page: currentPage + 1, completion: completion)
    }
    
    func refreshMembers(completion: @escaping () -> Void = {}) {
        fetchMembers(page: 1, completion: completion)
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
    
    func loadMoreIfNeeded(currentMember: MemberDetails) {
        guard let lastMember = members.last else { return }
        if currentMember == lastMember &&
            !isLoading &&
            currentPage < totalPages {
            print("Loading more members: page \(currentPage + 1)")
            fetchMembers(page: currentPage + 1)
        }
    }
}
