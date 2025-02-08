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
    func test_loginSuccess() async throws {
        let expectation = expectation(description: "Login success")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let jsonResponse = ["success": true]
            let data = try! JSONEncoder().encode(jsonResponse)
            return (response, data)
        }
        do {
            try await webservice.login(username: "JohnDoe", password: "Password")
            expectation.fulfill()
        } catch {
            XCTFail("Expected success but got failure: \(error)")
        }
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    func test_loginFailure() async throws {
        let expectation = self.expectation(description: "Login fails")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            let jsonResponse = ["success": false]
            let data = try! JSONEncoder().encode(jsonResponse)
            return (response, data)
        }
        do {
            try await webservice.login(username: "WrongUser", password: "WrongPass")
            XCTFail("Expected failure but got success")
        } catch(let error) {
            if let error = error as? NetworkError {
                XCTAssertEqual(error, NetworkError.notAuthenticated)
                expectation.fulfill()
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    func test_loginBadRequest() async throws {
        let expectation = self.expectation(description: "Login bad request")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            let data = Data()
            return (response, data)
        }
        do {
            try await webservice.login(username: "User", password: "Pass")
            XCTFail("Expected failed but received success response")
        } catch(let error) {
            if let error = error as? NetworkError {
                XCTAssertEqual(error, .badRequest)
                expectation.fulfill()
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_loginDecodingError() async throws {
        let expectation = self.expectation(description: "Login decoding error")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let invalidJSON = "{ invalid json }".data(using: .utf8)!
            return (response, invalidJSON)
        }
        do {
            try await webservice.login(username: "User", password: "Pass")
            XCTFail("Expected failed but received success response")
        } catch(let error) {
            if let error = error as? NetworkError {
                XCTAssertEqual(error, .decodingError)
                expectation.fulfill()
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_loginNetworkError() async throws {
        let expectation = self.expectation(description: "Login decoding error")
        MockURLProtocol.requestHandler = { request in
            throw URLError(.notConnectedToInternet)
        }
        do {
            try await webservice.login(username: "User", password: "Pass")
            XCTFail("Expected failure but got success")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
        await fulfillment(of: [expectation], timeout: 3)
    }
}
