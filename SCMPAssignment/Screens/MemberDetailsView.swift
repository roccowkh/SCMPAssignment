//
//  MemberDetailsView.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import SwiftUI

struct MemberDetailsView: View {
    let member: MemberDetails

    var body: some View {
        VStack(spacing: 24) {
            // Avatar
            AsyncImage(url: URL(string: member.avatar)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.blue)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .padding(.top, 40)

            // Name
            Text(member.fullName)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 8)

            // Email
            Text(member.email)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Member Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MemberDetailsView(
        member: MemberDetails(
            id: 1,
            email: "john@example.com",
            firstName: "John",
            lastName: "Doe",
            avatar: "https://example.com/avatar.jpg"
        )
    )
} 
