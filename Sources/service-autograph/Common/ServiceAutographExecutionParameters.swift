//
//  ServiceAutographExecutionParameters.swift
//  service-autograph
//
//  Created by incetro on 3/26/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Autograph

// MARK: - ServiceAutographExecutionParameters

public enum ServiceAutographExecutionParameters: String {

    /// Services protocols folder
    case services = "-services"

    /// Services destination folder
    case output = "-output"

    /// Plain objects folder
    case plains = "-plains"

    /// Current project name
    case projectName = "-project_name"
}

// MARK: - ExecutionParameters

public extension AutographExecutionParameters {

    subscript(_ parameter: ServiceAutographExecutionParameters) -> String? {
        self[parameter.rawValue]
    }
}
