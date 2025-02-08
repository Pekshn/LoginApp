//
//  Untitled.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

protocol NetworkService {
    func login(username: String, password: String) async throws
}

class Webservice: NetworkService {
    
    //MARK: - Properties
    private var session: URLSession
    
    //MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(username: String, password: String) async throws {
        let url = URL(string: "https://mango-persistent-organ.glitch.me/login")!
        let params = ["username": username, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(params)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badRequest
        }
        if httpResponse.statusCode == 401 {
            throw NetworkError.notAuthenticated
        }
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        if !loginResponse.success {
            throw NetworkError.notAuthenticated
        }
    }
}
