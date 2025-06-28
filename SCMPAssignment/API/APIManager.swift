//
//  APIManager.swift
//  SCMPAssignment
//
//  Created by Rocco Wong on 28/6/2025.
//

import Foundation
import Moya

final class APIManager {
    static let shared = APIManager()
    private let provider = MoyaProvider<APITarget>(plugins: [
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // Logs network requests
    ])
    private init() {}
    
    struct LoginResponse: Codable {
        let token: String?
        let error: String?
    }
    
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let loginRequest = LoginRequest(email: email, password: password)
        provider.request(.login(request: loginRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    if let token = loginResponse.token {
                        completion(.success(token))
                    } else if let error = loginResponse.error {
                        completion(.failure(NSError(domain: "APIManager", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: error])))
                    } else {
                        completion(.failure(NSError(domain: "APIManager", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
} 
