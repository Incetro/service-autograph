//
//  Service.swift
//  Sandbox
//
//  Created by incetro on 3/21/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - Service

class Service {

    // MARK: - Properties

    /// Background working queue
    let operationQueue: OperationQueue

    /// Main queue for callbacks
    let completionQueue: OperationQueue

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - operationQueue: background working queue
    ///   - completionQueue: main queue for callbacks
    init(
        operationQueue: OperationQueue = OperationQueue(),
        completionQueue: OperationQueue = OperationQueue.main
    ) {
        self.operationQueue = operationQueue
        self.completionQueue = completionQueue
    }

    // MARK: - Useful

    /// Assemble a sync/async call object.
    /// - Parameter main: main execution method
    func createCall<Payload>(
        main: @escaping ServiceCall<Payload>.Main
    ) -> ServiceCall<Payload> {
        ServiceCall(
            operationQueue: operationQueue,
            callbackQueue: completionQueue,
            main: main
        )
    }

    /// Assemble a async call object.
    /// - Parameter main: main execution method
    func createCancelableCall<Payload>(
        main: @escaping CancelableServiceCall<Payload>.Main
    ) -> CancelableServiceCall<Payload> {
        CancelableServiceCall(
            operationQueue: operationQueue,
            callbackQueue: completionQueue,
            main: main
        )
    }
}
