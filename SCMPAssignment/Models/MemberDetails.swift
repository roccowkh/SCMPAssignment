//
//  MemberDetails.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import Foundation

struct MemberDetails: Codable, Identifiable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    
    // Computed property for full name
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // Computed property for initials
    var initials: String {
        let firstInitial = firstName.prefix(1).uppercased()
        let lastInitial = lastName.prefix(1).uppercased()
        return "\(firstInitial)\(lastInitial)"
    }
    
    // Custom coding keys to handle snake_case to camelCase conversion
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
} 
