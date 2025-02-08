//
//  NetworkServiceFactory.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

class NetworkServiceFactory {
    
    //MARK: - Create NetworkService
    static func create() -> NetworkService {
        let env = ProcessInfo.processInfo.environment["ENV"]
        if let env = env {
            if env == "TEST" {
                return MockWebService()
            } else {
                return Webservice()
            }
        }
        return Webservice()
    }
}
