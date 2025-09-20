//
//  AuthError.swift
//  Demo
//
//  Created by Mathias La Rochelle on 2025-09-12.
//

import Foundation

enum AuthError: Error, CaseIterable {
    case invalidEmail
    case emailNotFound
    case passwordNotFound
    
    var message: String {
        switch self {
        case .invalidEmail:
            return "The e-mail address is invalid."
        case .emailNotFound:
            return "No account associated to this e-mail."
        case .passwordNotFound:
            return "No account associated to this password."
        }
    }
}
