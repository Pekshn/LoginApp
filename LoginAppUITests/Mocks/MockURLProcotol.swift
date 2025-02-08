//
//  MockURLProcotol.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    //MARK: - Properties
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    //MARK: - Lifecycle
    override class func canInit(with request: URLRequest) -> Bool {
        print("Intercepted request: \(request.url?.absoluteString ?? "Unknown URL")")
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Request handler is not set")
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
