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
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(memberViewModel)
        }
    }
}
