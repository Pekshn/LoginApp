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
    func test_loginSuccess() {
        viewModel.username = "JohnDoe"
        viewModel.password = "Password"
        let expectation = self.expectation(description: "Login success")
        viewModel.login()
        XCTAssertTrue(viewModel.isLoading, "Login request should set isLoading to true")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.loginStatus, .authenticated)
            XCTAssertFalse(self.viewModel.isLoading, "Login response should set isLoading to false")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loginFailure() {
        viewModel.username = "WrongUser"
        viewModel.password = "WrongPass"
        let expectation = self.expectation(description: "Login fails")
        viewModel.login()
        XCTAssertTrue(viewModel.isLoading, "Login request should set isLoading to true")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.loginStatus, .denied)
            XCTAssertFalse(self.viewModel.isLoading, "Login response should set isLoading to false")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_loginValidationFailure() {
        viewModel.username = ""
        viewModel.password = ""
        viewModel.login()
        XCTAssertEqual(viewModel.loginStatus, .validationFailed)
        XCTAssertEqual(viewModel.errorMessage, "Required fields are missing")
    }
    
    func test_isLoadingResetsOnValidationFailure() {
        viewModel.username = ""
        viewModel.password = ""
        viewModel.login()
        XCTAssertFalse(viewModel.isLoading, "IsLoading should be false if validation fails")
    }
}
