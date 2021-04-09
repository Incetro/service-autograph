//
//  TypeSpecification.swift
//  service-autograph
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis

// MARK: - TypeSpecification

extension TypeSpecification {

    var isCollection: Bool {
        switch self {
        case .array, .map:
            return true
        default:
            return false
        }
    }

    var serviceCallReturnType: ServiceCallReturnType {
        switch self {
        case .generic(let name, let constraints):

            let cancelable: Bool

            if name == "ServiceCall" {
                cancelable = false
            } else if name == "CancelableServiceCall" {
                cancelable = true
            } else {
                return .error
            }

            let payloadType: TypeSpecification

            if let first = constraints.first {
                payloadType = first
            } else {
                return .error
            }

            if cancelable {
                return .cancelableServiceCall(payloadType: payloadType)
            } else {
                return .serviceCall(payloadType: payloadType)
            }

        default:
            return .error
        }
    }

    enum ServiceCallReturnType {
        case serviceCall(payloadType: TypeSpecification)
        case cancelableServiceCall(payloadType: TypeSpecification)
        case error
    }
}
