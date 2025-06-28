//
//  SCMPAssignmentApp.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

@main
struct SCMPAssignmentApp: App {
    // Create a shared instance of MemberViewModel
    @StateObject private var memberViewModel = MemberViewModel()
    @State private var isLoggedIn = KeychainHelper.shared.read(forKey: "userToken") != nil
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MemberListScreen(isLoggedIn: $isLoggedIn)
                    .environmentObject(memberViewModel)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
