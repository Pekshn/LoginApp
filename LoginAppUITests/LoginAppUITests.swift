//
//  LoginAppUITests.swift
//  LoginAppUITests
//
//  Created by Petar  on 8.2.25..
//

import XCTest

final class WhenUserClicksOnLoginButton: XCTestCase {
    
    //MARK: - Properties
    private var app: XCUIApplication!
    private var loginPageObject: LoginPageObject!
    
    //MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        loginPageObject = LoginPageObject(app: app)
        continueAfterFailure = false
        app.launchEnvironment = ["ENV": "TEST"]
        app.launch()
    }
    
    //MARK: - Testing methods
    func test_shouldDisplayErrorMessageForMissingRequiredFields() {
        loginPageObject.usernameTextField.tap()
        loginPageObject.usernameTextField.typeText("")
        loginPageObject.passwordTextField.tap()
        loginPageObject.passwordTextField.typeText("")
        loginPageObject.loginButton.tap()
        XCTAssertEqual(loginPageObject.messageText.label, "Required fields are missing")
    }
    
    func test_shouldNavigateToHomeOnSuccessAuthentication() {
        loginPageObject.usernameTextField.tap()
        loginPageObject.usernameTextField.typeText("JohnDoe")
        loginPageObject.passwordTextField.tap()
        loginPageObject.passwordTextField.typeText("Password")
        loginPageObject.loginButton.tap()
        XCTAssertTrue(loginPageObject.home.waitForExistence(timeout: 0.5))
    }
    
    func test_shouldDisplayErrorMessageForInvalidCredentials() {
        loginPageObject.usernameTextField.tap()
        loginPageObject.usernameTextField.typeText("WrongUser")
        loginPageObject.passwordTextField.tap()
        loginPageObject.passwordTextField.typeText("WrongPass")
        loginPageObject.loginButton.tap()
        XCTAssertEqual(loginPageObject.messageText.label, "Invalid credentials")
    }
}
