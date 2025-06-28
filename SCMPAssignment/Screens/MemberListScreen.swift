//
//  MemberListScreen.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberListScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Member List Screen")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .navigationTitle("Members")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MemberListScreen()
} 
