//
//  APITarget.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import Moya
import Foundation

enum APITarget {
    case login(request: LoginRequest)
    case fetchMember(page: Int)
}

extension APITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://reqres.in/api")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .fetchMember:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .fetchMember:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestCompositeData(
                bodyData: try! JSONEncoder().encode(request),
                urlParameters: ["delay": "5"]
            )
        case .fetchMember(let page):
            return .requestParameters(
                parameters: ["page": page, "delay": "5"],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json", "x-api-key":"reqres-free-v1"]
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return """
            { "token": "QpwL5tke4Pnpja7X4" }
            """.data(using: .utf8)!
        case .fetchMember:
            return """
            {
                "page": 1,
                "per_page": 6,
                "total": 12,
                "total_pages": 2,
                "data": [
                    {
                        "id": 1,
                        "email": "george.bluth@reqres.in",
                        "first_name": "George",
                        "last_name": "Bluth",
                        "avatar": "https://reqres.in/img/faces/1-image.jpg"
                    }
                ]
            }
            """.data(using: .utf8)!
        }
    }
}
