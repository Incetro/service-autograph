//
//  CompanyPlainObject.swift
//  Sandbox
//
//  Created by incetro on 4/3/21.
//

import SDAO
import Codex

// MARK: - CompanyPlainObject

/// @realm
struct CompanyPlainObject: Plain, Equatable {

    // MARK: - Properties

    var uniqueId: UniqueID {
        .init(rawValue: name)
    }

    /// Company name
    let name: String

    /// Catch phrase string
    let catchPhrase: String
}

// MARK: - Codable

extension CompanyPlainObject: Codable {

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        name = try decoder.decode("name")
        catchPhrase = try decoder.decode("catchPhrase")
    }

    // MARK: - Encodable

    func encode(to encoder: Encoder) throws {
        try encoder.encode(name, for: "name")
        try encoder.encode(catchPhrase, for: "catchPhrase")
    }
}
