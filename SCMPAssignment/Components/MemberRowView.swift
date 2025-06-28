//
//  MemberRowView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberRowView: View {
    let member: MemberDetails
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar
            AsyncImage(url: URL(string: member.avatar)) { phase in
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
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
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
