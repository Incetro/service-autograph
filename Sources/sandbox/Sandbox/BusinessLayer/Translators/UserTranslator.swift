//
//  UserTranslator.swift
//  Sandbox
//
//  Generated automatically by dao-autograph
//  https://github.com/Incetro/dao-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import SDAO
import Monreau

// MARK: - UserTranslator

final class UserTranslator {

    // MARK: - Aliases

    typealias PlainModel = UserPlainObject
    typealias DatabaseModel = UserModelObject

    /// User storage
    private lazy var userStorage = RealmStorage<UserModelObject>(configuration: self.configuration)

    /// RealmConfiguration instance
    private let configuration: RealmConfiguration

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - configuration: current realm db config
    init(configuration: RealmConfiguration) {
        self.configuration = configuration
    }
}

// MARK: - Translator

extension UserTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        guard let address = model.address else {
            throw NSError(
                domain: "com.incetro.address-translator",
                code: 1000,
                userInfo: [
                    NSLocalizedDescriptionKey: "Cannot find AddressModelObject instance for UserPlainObject with id: '\(model.uniqueId)'"
                ]
            )
        }
        guard let company = model.company else {
            throw NSError(
                domain: "com.incetro.company-translator",
                code: 1000,
                userInfo: [
                    NSLocalizedDescriptionKey: "Cannot find CompanyModelObject instance for UserPlainObject with id: '\(model.uniqueId)'"
                ]
            )
        }
        return UserPlainObject(
            id: model.id,
            name: model.name,
            username: model.username,
            email: model.email,
            phone: model.phone,
            website: model.website,
            address: try AddressTranslator(configuration: configuration).translate(model: address),
            company: try CompanyTranslator(configuration: configuration).translate(model: company)
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try userStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }

    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.id = plain.id
        databaseModel.name = plain.name
        databaseModel.username = plain.username
        databaseModel.email = plain.email
        databaseModel.phone = plain.phone
        databaseModel.website = plain.website
        databaseModel.address = try AddressTranslator(configuration: configuration).translate(plain: plain.address)
        databaseModel.company = try CompanyTranslator(configuration: configuration).translate(plain: plain.company)
    }
}