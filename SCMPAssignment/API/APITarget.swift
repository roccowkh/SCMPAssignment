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
}

extension APITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://reqres.in/api")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestCompositeData(
                bodyData: try! JSONEncoder().encode(request),
                urlParameters: ["delay": "5"]
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
        }
    }
}
