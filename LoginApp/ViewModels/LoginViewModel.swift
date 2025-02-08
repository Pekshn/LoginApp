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
    @Published var isLoading: Bool = false
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
    
    @MainActor
    func login() async {
        if username.isEmpty || password.isEmpty {
            self.loginStatus = .validationFailed
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            try await service.login(username: username, password: password)
            self.loginStatus = .authenticated
            self.isLoading = false
        } catch {
            self.loginStatus = .denied
            self.isLoading = false
        }
    }
}
