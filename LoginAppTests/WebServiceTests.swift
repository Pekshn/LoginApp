//
//  WebServiceTests.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import XCTest

class WebserviceTests: XCTestCase {
    
    //MARK: - Properties
    var webservice: Webservice!
    var session: URLSession!
    
    //MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        webservice = Webservice(session: session)
    }
    
    override func tearDown() {
        webservice = nil
        session = nil
        super.tearDown()
    }
    
    //MARK: - Test methods
    func test_loginSuccess() {
        let expectation = self.expectation(description: "Login success")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let jsonResponse = ["success": true]
            let data = try! JSONEncoder().encode(jsonResponse)
            return (response, data)
        }
        webservice.login(username: "JohnDoe", password: "Password") { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_loginFailure() {
        let expectation = self.expectation(description: "Login fails")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            let jsonResponse = ["success": false]
            let data = try! JSONEncoder().encode(jsonResponse)
            return (response, data)
        }
        webservice.login(username: "WrongUser", password: "WrongPass") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .notAuthenticated)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_loginBadRequest() {
        let expectation = self.expectation(description: "Login bad request")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            let data = Data()
            return (response, data)
        }
        webservice.login(username: "User", password: "Pass") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .badRequest)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_loginDecodingError() {
        let expectation = self.expectation(description: "Login decoding error")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let invalidJSON = "{ invalid json }".data(using: .utf8)!
            return (response, invalidJSON)
        }
        webservice.login(username: "User", password: "Pass") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_loginNetworkError() {
        let expectation = self.expectation(description: "Login network error")
        MockURLProtocol.requestHandler = { request in
            throw URLError(.notConnectedToInternet)
        }
        webservice.login(username: "User", password: "Pass") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .badRequest)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
