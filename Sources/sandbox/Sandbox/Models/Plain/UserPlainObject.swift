//
//  UserPlainObject.swift
//  Sandbox
//
//  Created by incetro on 4/3/21.
//

import SDAO
import Codex

// MARK: - UserPlainObject

/// @realm
struct UserPlainObject: Plain, Equatable {

    // MARK: - Properties

    var uniqueId: UniqueID {
        .init(value: id)
    }

    /// Unique identifier
    let id: Int

    /// Name value
    let name: String

    /// Username
    let username: String

    /// Email address
    let email: String

    /// Phone number
    let phone: String

    /// Website link
    let website: String

    /// Address value
    let address: AddressPlainObject

    /// User's company
    let company: CompanyPlainObject
}

// MARK: - Codable

extension UserPlainObject: Codable {

    // MARK: - Decodable

    init(from decoder: Decoder) throws {
        id = try decoder.decode("id")
        name = try decoder.decode("name")
        username = try decoder.decode("username")
        email = try decoder.decode("email")
        phone = try decoder.decode("phone")
        website = try decoder.decode("website")
        address = try decoder.decode("address")
        company = try decoder.decode("company")
    }

    // MARK: - Encodable

    func encode(to encoder: Encoder) throws {
        try encoder.encode(id, for: "id")
        try encoder.encode(name, for: "name")
        try encoder.encode(username, for: "username")
        try encoder.encode(email, for: "email")
        try encoder.encode(phone, for: "phone")
        try encoder.encode(website, for: "website")
        try encoder.encode(address, for: "address")
        try encoder.encode(company, for: "company")
    }
}
