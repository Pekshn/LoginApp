//
//  Untitled.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

protocol NetworkService {
    func login(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void)
}

class Webservice: NetworkService {
    
    //MARK: - Properties
    private var session: URLSession
    
    //MARK: - Init
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = URL(string: "https://mango-persistent-organ.glitch.me/login")!
        let data = ["username": username, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        
        session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.badRequest))
                return
            }
            guard let data = data, error == nil else {
                completion(.failure(.badRequest))
                return
            }
            if httpResponse.statusCode == 401 {
                completion(.failure(.notAuthenticated))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            if loginResponse.success {
                completion(.success(()))
            } else {
                completion(.failure(.notAuthenticated))
            }
        }.resume()
    }
}
