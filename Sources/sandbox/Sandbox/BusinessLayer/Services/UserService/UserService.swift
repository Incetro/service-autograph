//
//  UserService.swift
//  Sandbox
//
//  Created by incetro on 4/3/21.
//

import Foundation

// MARK: - UserService

/// @service
protocol UserService {

    /// Obtain all available users
    /// @url /users
    /// @persist
    func obtain() -> ServiceCall<[UserPlainObject]>

    /// Obtain users with pagination
    /// @url /users
    /// @persist
    func obtain(
        page: Int,    /// @header X-Pagination-Current-Page
        pageSize: Int /// @header X-Pagination-Per-Page
    ) -> ServiceCall<[UserPlainObject]>

    /// Obtain user by its id
    /// @url /users/{id}
    /// @persist
    /// - Parameter id: user identifier
    func obtain(
        userId id: Int /// @url
    ) -> ServiceCall<UserPlainObject>

    /// Obtain users list who lives in the given city
    /// @url /users
    /// - Parameter city: city value
    func obtain(
        inCity city: String /// @query address.city
    ) -> ServiceCall<[UserPlainObject]>

    /// Create a new user object
    /// @url /users
    /// @post
    /// @persist
    /// - Parameter user: new user
    func create(
        user: UserPlainObject /// @json
    ) -> ServiceCall<UserPlainObject>

    /// Update the given user's name
    /// @url /users/{id}
    /// @patch
    /// @persist
    /// - Parameters:
    ///   - id: user identifier
    ///   - name: new name value
    func update(
        userId id: Int, /// @url
        name: String    /// @json
    ) -> ServiceCall<UserPlainObject>

    /// Update full user model
    /// @url /users/{user.id}
    /// @put
    /// - Parameter user: new user model
    func update(
        user: UserPlainObject /// @url user.id; @json
    ) -> CancelableServiceCall<Void>

    /// Delete the given user
    /// @url /users/{id}
    /// @delete
    /// @erase
    /// - Parameter id: user identifier
    func delete(
        userId id: Int /// @url
    ) -> ServiceCall<Void>

    /// Obtain local users (from database)
    /// @read
    func read() -> ServiceCall<[UserPlainObject]>

    /// Read the given user from local database
    /// @read
    /// - Parameter id: target user id
    func read(userId id: Int) -> ServiceCall<UserPlainObject?>

    /// Read the given users from local database
    /// @read
    /// - Parameter ids: target users identifiers
    func read(userIds ids: [Int]) -> ServiceCall<[UserPlainObject]>

    /// Erase all users from local database
    /// @erase
    func erase() -> ServiceCall<Void>

    /// Erase the given user from local database
    /// @erase
    /// - Parameter id: target user id
    func erase(userId id: Int) -> ServiceCall<Void>

    /// Erase the given users from local database
    /// @erase
    /// - Parameter ids: target users identifiers
    func erase(userIds ids: [Int]) -> ServiceCall<Void>
}
