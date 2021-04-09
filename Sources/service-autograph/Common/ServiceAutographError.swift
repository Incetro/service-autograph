//
//  ServiceAutographError.swift
//  service-autograph
//
//  Created by incetro on 3/26/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - ServiceAutographError

public enum ServiceAutographError {

    // MARK: - Cases

    /// You haven't specified a path to services
    case noServicesFolder

    /// You haven't specified your project name
    case noProjectName

    /// We cannot translate the given type to other db type
    case unknownType(String, propertyName: String)
}

// MARK: - LocalizedError

extension ServiceAutographError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noServicesFolder:
            return "You haven't specified a path to plain objects"
        case .noProjectName:
            return "You haven't specified your project name"
        case let .unknownType(type, propertyName: propertyName):
            return "We cannot translate the given type \(type) to other db type for property \(propertyName)"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension ServiceAutographError: CustomDebugStringConvertible {

    public var debugDescription: String {
        errorDescription ?? ""
    }
}
