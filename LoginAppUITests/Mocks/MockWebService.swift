//
//  MockWebService.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

class MockWebService: NetworkService {
    
    //MARK: - Methods
    func login(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if username == "JohnDoe" && password == "Password" {
            return completion(.success(()))
        } else {
            return completion(.failure(.notAuthenticated))
        }
    }
}
