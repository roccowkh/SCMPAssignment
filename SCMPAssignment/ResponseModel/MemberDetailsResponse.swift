//
//  MemberDetailsResponse.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import Foundation

struct MemberDetailsResponse: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [MemberDetails]
    let support: SupportInfo
    
    // Custom coding keys to handle snake_case to camelCase conversion
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
        case support
    }
}

struct SupportInfo: Codable {
    let url: String
    let text: String
}
