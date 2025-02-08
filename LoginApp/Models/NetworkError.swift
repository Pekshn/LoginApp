//
//  NetworkError.swift
//  LoginApp
//
//  Created by Petar  on 8.2.25..
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case notAuthenticated
}
