//
//  AddressModelObject.swift
//  Sandbox
//
//  Generated automatically by dao-autograph
//  https://github.com/Incetro/dao-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import SDAO
import RealmSwift

// MARK: - AddressModelObject

final class AddressModelObject: RealmModel {

    // MARK: - Properties

    /// Street line
    @objc dynamic var street = ""

    /// Suite value
    @objc dynamic var suite = ""

    /// City name
    @objc dynamic var city = ""

    /// ZipCode value
    @objc dynamic var zipcode = ""
}
