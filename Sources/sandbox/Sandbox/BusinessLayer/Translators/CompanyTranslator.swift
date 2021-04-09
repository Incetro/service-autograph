//
//  CompanyTranslator.swift
//  Sandbox
//
//  Generated automatically by dao-autograph
//  https://github.com/Incetro/dao-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import SDAO
import Monreau

// MARK: - CompanyTranslator

final class CompanyTranslator {

    // MARK: - Aliases

    typealias PlainModel = CompanyPlainObject
    typealias DatabaseModel = CompanyModelObject

    /// Company storage
    private lazy var companyStorage = RealmStorage<CompanyModelObject>(configuration: self.configuration)

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

extension CompanyTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        CompanyPlainObject(
            name: model.name,
            catchPhrase: model.catchPhrase
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try companyStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DatabaseModel()
        try translate(from: plain, to: model)
        return model
    }

    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.name = plain.name
        databaseModel.catchPhrase = plain.catchPhrase
    }
}