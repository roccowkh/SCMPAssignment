//
//  MemberRowView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberRowView: View {
    let member: MemberDetails
    let refreshID: UUID
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar with network-aware identifier
            AsyncImage(url: URL(string: member.avatar)) { phase in
                ZStack {
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        // Error placeholder
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.blue)
                    } else {
                        // Loading placeholder
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    
                    // Show spinner overlay when loading
                    if case .empty = phase {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                            .opacity(0.8)
                    }
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .id("\(member.id)-\(refreshID)") // Force refresh when refreshID changes
            
            // Member Info
            VStack(alignment: .leading, spacing: 4) {
                Text(member.fullName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(member.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Arrow indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 50)
        .padding(.horizontal, 15)
    }
} 
