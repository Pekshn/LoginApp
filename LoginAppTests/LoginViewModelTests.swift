//
//  LoginViewModelTests.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import XCTest

class LoginViewModelTests: XCTestCase {
    
    //MARK: - Properties
    var viewModel: LoginViewModel!
    var mockService: MockWebService!
    
    //MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockService = MockWebService()
        viewModel = LoginViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    //MARK: - Test methods
    func test_loginSuccess() async {
        viewModel.username = "JohnDoe"
        viewModel.password = "Password"
        XCTAssertFalse(viewModel.isLoading, "Before login, isLoading should be false")
        await viewModel.login()
        XCTAssertEqual(viewModel.loginStatus, .authenticated, "Login status should be .authenticated")
        XCTAssertFalse(viewModel.isLoading, "Login response should set isLoading to false")
    }
    
    func test_loginFailure() async {
        viewModel.username = "WrongUser"
        viewModel.password = "WrongPass"
        XCTAssertFalse(viewModel.isLoading, "Before login, isLoading should be false")
        await viewModel.login()
        XCTAssertEqual(self.viewModel.loginStatus, .denied, "Login status should be .denied")
        XCTAssertFalse(self.viewModel.isLoading, "Login response should set isLoading to false")
    }
    
    func test_loginValidationFailure() async {
        viewModel.username = ""
        viewModel.password = ""
        await viewModel.login()
        XCTAssertEqual(viewModel.loginStatus, .validationFailed)
        XCTAssertEqual(viewModel.errorMessage, "Required fields are missing")
    }
    
    func test_isLoadingResetsOnValidationFailure() async {
        viewModel.username = ""
        viewModel.password = ""
        await viewModel.login()
        XCTAssertFalse(viewModel.isLoading, "IsLoading should be false if validation fails")
    }
}
