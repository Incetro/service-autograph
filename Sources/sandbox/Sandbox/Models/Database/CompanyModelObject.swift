//
//  CompanyModelObject.swift
//  Sandbox
//
//  Generated automatically by dao-autograph
//  https://github.com/Incetro/dao-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import SDAO
import RealmSwift

// MARK: - CompanyModelObject

final class CompanyModelObject: RealmModel {

    // MARK: - Properties

    /// Company name
    @objc dynamic var name = ""

    /// Catch phrase string
    @objc dynamic var catchPhrase = ""
}
