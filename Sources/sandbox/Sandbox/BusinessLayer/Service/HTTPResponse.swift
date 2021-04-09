//
//  HTTPResponse.swift
//  Sandbox
//
//  Created by incetro on 7/24/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import HTTPTransport

typealias Parameters = [String: Any]

// MARK: - HTTPResponse

extension HTTPResponse {

    func dictionary(_ key: String) throws -> Parameters {
        try getJSONDictionary().unwrap()[key].unwrap(as: Parameters.self)
    }

    func array(_ key: String) throws -> [Parameters] {
        (try getJSONDictionary().unwrap()[key] as? [Parameters]) ?? [Parameters]()
    }
}
