//
//  MemberViewModel.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import Foundation
import SwiftUI
import Network

@MainActor
class MemberViewModel: ObservableObject {
    @Published var members: [MemberDetails] = [] {
        didSet {
            if !members.isEmpty {
                UserDefaultsHelper.shared.saveMemberList(members)
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 0
    @Published var totalMembers: Int = 0
    @Published var isActuallyOnline: Bool = true
    
    
    func fetchMembers(page: Int = 1, completion: @escaping () -> Void = {}) {
        isLoading = true
        errorMessage = nil
        
        APIManager.shared.fetchMembers(page: page) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // API call succeeded, so we're actually online
                    self.isActuallyOnline = true
                    
                    if page == 1 {
                        self.members = response.data
                        print("Updated members (replace): \(self.members.count)")
                    } else {
                        let newMembers = response.data.filter { newMember in
                            !self.members.contains(where: { $0.id == newMember.id })
                        }
                        self.members.append(contentsOf: newMembers)
                        print("Updated members (append): \(self.members.count)")
                    }
                    self.currentPage = response.page
                    self.totalPages = response.totalPages
                    self.totalMembers = response.total
                    self.isLoading = false
                case .failure(let error):
                    // Check if it's a network error to determine if we're actually offline
                    if let networkError = error as? URLError {
                        switch networkError.code {
                        case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
                            self.isActuallyOnline = false
                        default:
                            // Other errors (like server errors) don't necessarily mean we're offline
                            break
                        }
                    }
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
