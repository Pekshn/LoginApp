//
//  LoginAppUITestsLaunchTests.swift
//  LoginAppUITests
//
//  Created by Petar  on 8.2.25..
//

import XCTest

final class LoginAppUITestsLaunchTests: XCTestCase {
    
    //MARK: - Lifecycle
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testLaunch() throws { }
}
