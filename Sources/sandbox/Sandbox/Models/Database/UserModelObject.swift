//
//  UserModelObject.swift
//  Sandbox
//
//  Generated automatically by dao-autograph
//  https://github.com/Incetro/dao-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import SDAO
import RealmSwift

// MARK: - UserModelObject

final class UserModelObject: RealmModel {

    // MARK: - Properties

    /// Unique identifier
    @objc dynamic var id = 0

    /// Name value
    @objc dynamic var name = ""

    /// Username
    @objc dynamic var username = ""

    /// Email address
    @objc dynamic var email = ""

    /// Phone number
    @objc dynamic var phone = ""

    /// Website link
    @objc dynamic var website = ""

    /// Address value
    @objc dynamic var address: AddressModelObject?

    /// User's company
    @objc dynamic var company: CompanyModelObject?
}
