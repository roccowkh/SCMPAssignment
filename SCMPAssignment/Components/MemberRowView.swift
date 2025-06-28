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
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(member.initials)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                )
            
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
        .padding(.vertical, 8)
    }
} 