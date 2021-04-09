//
//  AddressPlainObject.swift
//  Sandbox
//
//  Created by incetro on 4/3/21.
//

import SDAO
import Codex

// MARK: - AddressPlainObject

/// @realm
struct AddressPlainObject: Plain, Equatable {

    // MARK: - Properties

    var uniqueId: UniqueID {
        .init(rawValue: city + zipcode + suite + street)
    }

    /// Street line
    let street: String

    /// Suite value
    let suite: String

    /// City name
    let city: String

    /// ZipCode value
    let zipcode: String
}

// MARK: - Codable

extension AddressPlainObject: Codable {

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        street = try decoder.decode("street")
        suite = try decoder.decode("suite")
        city = try decoder.decode("city")
        zipcode = try decoder.decode("zipcode")
    }

    // MARK: - Encodable

    func encode(to encoder: Encoder) throws {
        try encoder.encode(street, for: "street")
        try encoder.encode(suite, for: "suite")
        try encoder.encode(city, for: "city")
        try encoder.encode(zipcode, for: "zipcode")
    }
}
