//
//  UserServiceGeneratedImplementation.swift.swift
//  Sandbox
//
//  Generated automatically by service-autograph
//  https://github.com/Incetro/service-autograph
//
//  Copyright © 2020 Incetro Inc. All rights reserved.
//
// swiftlint:disable function_parameter_count
// synopsis:disable

import HTTPTransport

// MARK: - UserServiceGeneratedImplementation

final class UserServiceGeneratedImplementation: WebService {
    
    // MARK: - Properties

    /// UserDAO instance
    private let dao: UserDAO

    /// Default initializer
    /// - Parameters:
    ///   - dao: UserDAO instance
    ///   - transport: HTTPTransport instance
    init(
        dao: UserDAO,
        transport: HTTPTransport
    ) {
        self.dao = dao
        super.init(transport: transport)
    }
}

// MARK: - UserService

extension UserServiceGeneratedImplementation: UserService {
    
    /// Obtain all available users
    /// @url /users
    /// @persist
    func obtain() -> ServiceCall<[UserPlainObject]> {
        createCall { () -> Result<[UserPlainObject], Error> in

            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/users",
                parameters: [],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success(let response):
                let data = response.body.unwrap()
                let result = try data.decoded() as [UserPlainObject]
                try self.dao.persist(result)
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    /// Obtain users with pagination
    /// @url /users
    /// @persist
    func obtain(
        page: Int,     /// @header X-Pagination-Current-Page
        pageSize: Int  /// @header X-Pagination-Per-Page
    ) -> ServiceCall<[UserPlainObject]> {
        createCall { () -> Result<[UserPlainObject], Error> in

            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/users",
                headers: [
                    "X-Pagination-Current-Page": "\(page)",
                    "X-Pagination-Per-Page": "\(pageSize)"
                ],
                parameters: [],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success(let response):
                let data = response.body.unwrap()
                let result = try data.decoded() as [UserPlainObject]
                try self.dao.persist(result)
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    /// Obtain user by its id
    /// @url /users/{id}
    /// @persist
    /// - Parameter id: user identifier
    func obtain(
        userId id: Int  /// @url
    ) -> ServiceCall<UserPlainObject> {
        createCall { () -> Result<UserPlainObject, Error> in

            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/users/\(id)",
                parameters: [],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success(let response):
                let data = response.body.unwrap()
                let result = try data.decoded() as UserPlainObject
                try self.dao.persist(result)
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    /// Obtain users list who lives in the given city
    /// @url /users
    /// - Parameter city: city value
    func obtain(
        inCity city: String  /// @query address.city
    ) -> ServiceCall<[UserPlainObject]> {
        createCall { () -> Result<[UserPlainObject], Error> in

            let queryArguments = self.fillHTTPRequestParameters(
                self.queryParameters,
                with: [
                    "address.city": "\(city)"
                ]
            )

            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/users",
                parameters: [queryArguments],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success(let response):
                let data = response.body.unwrap()
                let result = try data.decoded() as [UserPlainObject]
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    /// Create a new user object
    /// @url /users
    /// @post
    /// @persist
    /// - Parameter user: new user
    func create(
        user: UserPlainObject  /// @json
    ) -> ServiceCall<UserPlainObject> {
        createCall { () -> Result<UserPlainObject, Error> in

            let jsonArguments = self.fillHTTPRequestParameters(
                self.jsonParameters,
                with: try user.dictionary()
            )

            let request = HTTPRequest(
                httpMethod: .post,
                endpoint: "/users",
                parameters: [jsonArguments],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success(let response):
                let data = response.body.unwrap()
                let result = try data.decoded() as UserPlainObject
                try self.dao.persist(result)
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

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
    ) -> ServiceCall<UserPlainObject> {
        createCall { () -> Result<UserPlainObject, Error> in

            let jsonArguments = self.fillHTTPRequestParameters(
                self.jsonParameters,
                with: [
                    "name": "\(name)"
                ]
            )

            let request = HTTPRequest(
                httpMethod: .patch,
                endpoint: "/users/\(id)",
                parameters: [jsonArguments],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success(let response):
                let data = response.body.unwrap()
                let result = try data.decoded() as UserPlainObject
                try self.dao.persist(result)
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    /// Update full user model
    /// @url /users/{user.id}
    /// @put
    /// - Parameter user: new user model
    func update(
        user: UserPlainObject  /// @url user.id; @json
    ) -> CancelableServiceCall<Void> {
        createCancelableCall { (this, completion: @escaping (Result<Void, Error>) -> Void) throws in

            let jsonArguments = self.fillHTTPRequestParameters(
                self.jsonParameters,
                with: try user.dictionary()
            )
            let request = HTTPRequest(
                httpMethod: .put,
                endpoint: "/users/\(user.id)",
                parameters: [jsonArguments],
                base: self.baseRequest
            )

            let httpCall = self.transport.send(request: request) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }

            this.cancelClosure = {
                httpCall.cancel()
            }
        }
    }

    /// Delete the given user
    /// @url /users/{id}
    /// @delete
    /// @erase
    /// - Parameter id: user identifier
    func delete(
        userId id: Int  /// @url
    ) -> ServiceCall<Void> {
        createCall { () -> Result<Void, Error> in

            let request = HTTPRequest(
                httpMethod: .delete,
                endpoint: "/users/\(id)",
                parameters: [],
                base: self.baseRequest
            )

            let result = self.transport.send(request: request)

            switch result {
            case .success:
                try self.dao.erase(byPrimaryKey: id)
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    /// Obtain local users (from database)
    /// @read
    func read() -> ServiceCall<[UserPlainObject]> {
        createCall { () -> Result<[UserPlainObject], Error> in
            .success(try self.dao.read())
        }
    }

    /// Read the given user from local database
    /// @read
    /// - Parameter id: target user id
    func read(
        userId id: Int
    ) -> ServiceCall<UserPlainObject?> {
        createCall { () -> Result<UserPlainObject?, Error> in
            let result = try self.dao.read(byPrimaryKey: id)
            return .success(result)
        }
    }

    /// Read the given users from local database
    /// @read
    /// - Parameter ids: target users identifiers
    func read(
        userIds ids: [Int]
    ) -> ServiceCall<[UserPlainObject]> {
        createCall { () -> Result<[UserPlainObject], Error> in
            let result = try self.dao.read(byPrimaryKeys: ids)
            return .success(result)
        }
    }

    /// Erase all users from local database
    /// @erase
    func erase() -> ServiceCall<Void> {
        createCall { () -> Result<Void, Error> in
            return .success(try self.dao.erase())
        }
    }

    /// Erase the given user from local database
    /// @erase
    /// - Parameter id: target user id
    func erase(
        userId id: Int
    ) -> ServiceCall<Void> {
        createCall { () -> Result<Void, Error> in
            return .success(try self.dao.erase(byPrimaryKey: id))
        }
    }

    /// Erase the given users from local database
    /// @erase
    /// - Parameter ids: target users identifiers
    func erase(
        userIds ids: [Int]
    ) -> ServiceCall<Void> {
        createCall { () -> Result<Void, Error> in
            return .success(try self.dao.erase(byPrimaryKeys: ids))
        }
    }
}
