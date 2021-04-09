//
//  Codable.swift
//  Sandbox
//
//  Created by incetro on 4/4/21.
//

import Foundation

// MARK: - Encodable

extension Encodable {

    func dictionary() throws -> Parameters {
        (try JSONSerialization.jsonObject(with: try encoded()) as? Parameters) ?? [:]
    }
}
