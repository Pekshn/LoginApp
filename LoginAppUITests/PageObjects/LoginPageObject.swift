//
//  LoginPageObject.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import XCTest

class LoginPageObject {
    
    //MARK: - Properties
    var app: XCUIApplication
    
    //MARK: - Init
    init(app: XCUIApplication) {
        self.app = app
    }
    
    //MARK: - XCUIElements
    var usernameTextField: XCUIElement {
        app.textFields["usernameTextField"]
    }
    
    var passwordTextField: XCUIElement {
        app.textFields["passwordTextField"]
    }
    
    var loginButton: XCUIElement {
        app.buttons["loginButton"]
    }
    
    var messageText: XCUIElement {
        app.staticTexts["messageText"]
    }
    
    var home: XCUIElement {
        app.staticTexts["Home"]
    }
}
