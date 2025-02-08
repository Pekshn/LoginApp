//
//  MockWebService.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

class MockWebService: NetworkService {
    
    //MARK: - Methods
    func login(username: String, password: String) async throws {
        if username == "JohnDoe" && password == "Password" {
            return
        } else {
            throw NetworkError.notAuthenticated
        }
    }
}
