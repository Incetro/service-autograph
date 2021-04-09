//
//  ServiceCallResult.swift
//  Sandbox
//
//  Created by incetro on 3/23/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - ServiceCallResult

final class ServiceCallResult<Payload> {

    // MARK: - Aliases

    typealias Success = (Payload) -> Void
    typealias Failure = (Error) -> Void

    // MARK: - Properties

    /// Success block
    private(set) var successClosure: Success?

    /// Failure block
    private(set) var failureClosure: Failure?

    // MARK: - Initializers

    init() {
        successClosure = nil
        failureClosure = nil
    }

    // MARK: - Useful

    @discardableResult func success(_ block: Success?) -> Self {
        successClosure = block
        return self
    }

    @discardableResult func failure(_ block: Failure?) -> Self {
        failureClosure = block
        return self
    }
}
