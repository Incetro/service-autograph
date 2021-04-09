//
//  ServicePlainObject.swift
//  service-autograph
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis
import Foundation

// MARK: - ServicePlainObject

public struct ServicePlainObject {

    /// Service's protocol comment
    let comment: String?

    /// Service name
    let name: String

    /// True if the service is a part of
    /// some service's group (when one service
    /// has several implementations)
    let isGroupService: Bool

    /// Service's parent protocol name
    let parentProtocol: String

    /// Service's protocol methods
    let methods: [MethodSpecification]

    /// Detination URL
    let destination: String
}
