//
//  AddressTranslator.swift
//  Sandbox
//
//  Generated automatically by dao-autograph
//  https://github.com/Incetro/dao-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import SDAO
import Monreau

// MARK: - AddressTranslator

final class AddressTranslator {

    // MARK: - Aliases

    typealias PlainModel = AddressPlainObject
    typealias DatabaseModel = AddressModelObject

    /// Address storage
    private lazy var addressStorage = RealmStorage<AddressModelObject>(configuration: self.configuration)

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

extension AddressTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        AddressPlainObject(
            street: model.street,
            suite: model.suite,
            city: model.city,
            zipcode: model.zipcode
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try addressStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }

    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.street = plain.street
        databaseModel.suite = plain.suite
        databaseModel.city = plain.city
        databaseModel.zipcode = plain.zipcode
    }
}