//
//  LoginViewModel.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

class LoginViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var loginStatus: LoginStatus = .none
    private var service: NetworkService
    var errorMessage: String {
        switch loginStatus {
            case .denied:
                return "Invalid credentials"
            case .validationFailed:
                return "Required fields are missing"
            default:
                return ""
        }
    }
    
    //MARK: - Init
    init(service: NetworkService) {
        self.service = service
    }
}

//MARK: - Public API
extension LoginViewModel {
    
    func login() {
        if username.isEmpty || password.isEmpty {
            self.loginStatus = .validationFailed
            return
        }
        service.login(username: username, password: password) { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.loginStatus = .authenticated
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.loginStatus = .denied
                }
            }
        }
    }
}
