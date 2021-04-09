//
//  ServiceImplementationComposer.swift
//  service-autograph
//
//  Created by incetro on 3/26/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis
import Autograph

// MARK: - ServiceImplementationComposer

public final class ServiceImplementationComposer {

    // MARK: - Initializers

    public init() {
    }

    // MARK: - Private

    /// Constructs signed by service-autograph header
    /// - Parameters:
    ///   - filename: target file name
    ///   - projectName: current project name
    ///   - imports: necessary imports
    /// - Returns: signed by dao-autograph header
    private func headerComment(
        filename: String,
        projectName: String,
        imports: [String]
    ) -> String {
        let imports = imports.map { "import \($0)" }.joined(separator: "\n")
        return """
        //
        //  \(filename).swift
        //  \(projectName)
        //
        //  Generated automatically by service-autograph
        //  https://github.com/Incetro/service-autograph
        //
        //  Copyright © 2021 Incetro Inc. All rights reserved.
        //
        // swiftlint:disable function_parameter_count
        // synopsis:disable

        \(imports)

        """
    }

    /// Composes request parameters property declaration
    /// - Parameters:
    ///   - parametersList: request parameters list
    ///   - type: parameters type
    /// - Returns: request parameters property declaration
    private func composeRequestParameters(
        from parametersList: [String],
        withType type: String
    ) -> (type: String, content: String)? {
        guard !parametersList.isEmpty else { return nil }
        return (type, """

        let \(type)Arguments = self.fillHTTPRequestParameters(
            self.\(type)Parameters,
            with: [
                \(parametersList.dictString.adjust(2))
            ]
        )
        """.indent(3)
        )
    }

    /// Composes request parameters property declaration
    /// when we need to place an encoded object as a parameter
    /// - Parameters:
    ///   - parameter: request parameter
    ///   - type: parameters type
    /// - Returns: object-based request parameters property declaration
    private func composeEncodedRequestParameters(
        from parameter: String,
        withType type: String
    ) -> (type: String, content: String)? {
        return (type, """

        let \(type)Arguments = self.fillHTTPRequestParameters(
            self.\(type)Parameters,
            with: try \(parameter).dictionary()
        )
        """.indent(3)
        )
    }

    /// Composes HTTPRequest declaration
    /// - Parameters:
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    ///   - annotations: current method annotations
    ///   - arguments: current method arguments
    /// - Returns: HTTPRequest declaration
    private func composeHTTPRequest(
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters,
        usingAnnotations annotations: [AnnotationSpecification],
        arguments: [ArgumentSpecification]
    ) -> String {
        let allowedHttpMethods = ["get", "post", "put", "patch", "delete", "head", "options"]
        let httpMethod = annotations.map(\.name).first(where: allowedHttpMethods.contains) ?? "get"
        var endpoint = annotations["url"]?.value ?? ""
        arguments.forEach { argument in
            guard let urlPlaceholderName = argument.urlPlaceholderName else { return }
            let isDecodablePlaceholder = urlPlaceholderName.contains(".") && specifications.isDecodable(argument.type.verse)
            let isServiceEntityPlaceholder = urlPlaceholderName.contains("serviceEntity")
            if isDecodablePlaceholder || isServiceEntityPlaceholder {
                /// Here we have a situation when argument is a structure or a class and we want to use
                /// one of its properties as a url placeholder (property will be passes to annotation like `@url user.id`)
                endpoint = endpoint.replacingOccurrences(of: "{\(urlPlaceholderName)}", with: "\\(\(urlPlaceholderName))")
            } else {
                endpoint = endpoint.replacingOccurrences(of: "{\(urlPlaceholderName)}", with: "\\(\(argument.bodyName))")
            }
        }
        let parameters = Set(arguments.flatMap(\.annotations).map(\.name))
            .filter(["json", "query"].contains)
            .map { "\($0)Arguments" }
            .joined(separator: ", ")
        var headers = ""
        let headersDictStr = arguments.annotatedWith("header").dictString
        if headersDictStr != ":" {
            headers = """

            headers: [
                \(headersDictStr.adjust(1))
            ],
            """.indent
        }

        return """

        let request = HTTPRequest(
            httpMethod: .\(httpMethod),
            endpoint: "\(endpoint)",\(headers)
            parameters: [\(parameters)],
            base: self.baseRequest
        )
        """.indent(2)
    }

    /// Composes DAO method string for network method
    /// - Parameters:
    ///   - annotations: current method annotations
    ///   - arguments: current method arguments
    /// - Returns: DAO method string
    private func composeDAO(
        annotations: [AnnotationSpecification],
        arguments: [ArgumentSpecification]
    ) -> String {
        if annotations.contains(annotationName: "persist") {
            return """

                try self.dao.persist(result)
            """
        } else if annotations.contains(annotationName: "erase") {
            /// fatalError(annotations.map(\.name).joined(separator: ", "))
            if let idArg = arguments.first {
                switch idArg.type {
                case .array:
                    return """

                    try self.dao.erase(byPrimaryKeys: \(idArg.bodyName))
                    """
                default:
                    return """

                    try self.dao.erase(byPrimaryKey: \(idArg.bodyName))
                    """
                }
            } else {
                return """

                try self.dao.erase()
                """
            }
        } else {
            return ""
        }
    }

    /// Composes success block for network methods
    /// - Parameters:
    ///   - payloadType: return type
    ///   - annotations: current method annotations
    ///   - daoStr: DAO method string for network method
    /// - Returns: success block for network methods
    private func success(
        payloadType: TypeSpecification,
        annotations: [AnnotationSpecification],
        daoStr: String
    ) -> String {
        switch payloadType {
        case .integer,
             .doublePrecision,
             .floatingPoint,
             .boolean,
             .string:
            let jsonKey = annotations["result"]?.value ?? "result"
            return """
            case .success(let response):
                let json = try response.getJSONDictionary() ?? [:]
                let result = json["\(jsonKey)"].unwrap(as: \(payloadType.verse).self)
                return .success(result)
            """
        case .void:
            return """
            case .success:\(daoStr.indent)
                return .success(())
            """
        default:
            let dataLet: String
            if let array = annotations["array"]?.value {
                dataLet = "let data = try JSONSerialization.data(withJSONObject: try response.array(\"\(array)\"))"
            } else {
                dataLet = "let data = response.body.unwrap()"
            }
            return """
            case .success(let response):
                \(dataLet)
                let result = try data.decoded() as \(payloadType)\(daoStr)
                return .success(result)
            """
        }
    }

    /// Composes success block for network methods
    /// and CancellableServiceCall type
    /// - Parameters:
    ///   - payloadType: return type
    ///   - annotations: current method annotations
    /// - Returns: success block for network methods
    private func cancelableSuccess(
        payloadType: TypeSpecification,
        annotations: [AnnotationSpecification]
    ) -> String {
        switch payloadType {
        case .integer,
             .doublePrecision,
             .floatingPoint,
             .boolean,
             .string:
            let jsonKey = annotations["result"]?.value ?? "result"
            return """
            case .success(let response):
                do {
                    let json = try response.getJSONDictionary() ?? [:]
                    let result = json["\(jsonKey)"].unwrap(as: \(payloadType.verse).self)
                    return .success(result)
                } catch {
                    completion(.failure(error))
                }
            """
        case .void:
            return """
            case .success:
                completion(.success(()))
            """
        default:
            let dataLet: String
            if let array = annotations["array"]?.value {
                dataLet = "let data = try JSONSerialization.data(withJSONObject: try response.array(\"\(array)\"))"
            } else {
                dataLet = "let data = response.body.unwrap()"
            }
            return """
            case .success(let response):
                do {
                    \(dataLet)
                    let result = try data.decoded() as \(payloadType)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            """
        }
    }

    /// Composes ServiceCall body
    /// - Parameters:
    ///   - payloadType: return type
    ///   - requestParameters: parameters string
    ///   - httpRequestInit: HTTPRequest string
    ///   - success: success block declaration
    /// - Returns: ServiceCall body
    private func serviceCallBody(
        payloadType: String,
        requestParameters: [(type: String, content: String)],
        httpRequestInit: String,
        success: String
    ) -> String {
        var requestParametersSequenceStr = requestParameters.map(\.content).joined(separator: "\n")
        if !requestParametersSequenceStr.isEmpty {
            requestParametersSequenceStr += "\n"
        }
        return """
        createCall { () -> Result<\(payloadType), Error> in
            \(requestParametersSequenceStr)\(httpRequestInit.indent)

                    let result = self.transport.send(request: request)

                    switch result {
                    \(success.adjust(3))
                    case .failure(let error):
                        return .failure(error)
                    }
                }

        """
    }

    /// Composes CancellableServiceCall body
    /// - Parameters:
    ///   - payloadType: return type
    ///   - requestParameters: parameters string
    ///   - httpRequestInit: HTTPRequest string
    ///   - success: success block declaration
    /// - Returns: ServiceCall body
    private func cancelableServiceCallBody(
        payloadType: String,
        requestParameters: [(type: String, content: String)],
        httpRequestInit: String,
        success: String
    ) -> String {
        let requestParametersSequenceStr = requestParameters.map(\.content).joined(separator: "\n")
        return """
        createCancelableCall { (this, completion: @escaping (Result<\(payloadType), Error>) -> Void) throws in
            \(requestParametersSequenceStr)\(httpRequestInit.indent)

                    let httpCall = self.transport.send(request: request) { result in
                        switch result {
                        \(success.adjust(4))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }

                    this.cancelClosure = {
                        httpCall.cancel()
                    }
                }

        """
    }

    /// Composes service call body which works only with
    /// DAO CRUD interface, for example:
    ///
    /// `@persist` turns into
    /// `try self.dao.persist(object)` or `try self.dao.persist(objects)`
    ///
    /// `@erase` turns into
    /// `try self.dao.erase(byPrimaryKey: id)` or `try self.dao.erase(byPrimaryKeys: ids)`
    ///
    /// `@read` turns into
    /// `try self.dao.read()` or `try self.dao.read(byPrimaryKey: id)`
    ///
    /// `@count` turns into
    /// `try self.dao.count()`
    ///
    /// - Parameters:
    ///   - payloadType: service call payload type
    ///   - annotations: method annotations
    ///   - arguments: method parameters arguments
    private func composeDAOServiceCallBody(
        _ payloadType: TypeSpecification,
        annotations: [AnnotationSpecification],
        arguments: [ArgumentSpecification]
    ) -> String {
        let content: String
        if annotations.contains(annotationName: "persist") {
            let persistingArgumentName = arguments.first.unwrap().bodyName
            content = """
            let result = try self.dao.persist(\(persistingArgumentName))
            return .success(result)
            """
        } else if annotations.contains(annotationName: "read") {
            if let persistingArgument = arguments.first {
                switch persistingArgument.type {
                case .array:
                    content = """
                    let result = try self.dao.read(byPrimaryKeys: \(persistingArgument.bodyName))
                    return .success(result)
                    """
                default:
                    content = """
                    let result = try self.dao.read(byPrimaryKey: \(persistingArgument.bodyName))
                    return .success(result)
                    """
                }
            } else {
                content = """
                .success(try self.dao.read())
                """
            }
        } else if annotations.contains(annotationName: "erase") {
            if let persistingArgument = arguments.first {
                switch persistingArgument.type {
                case .array:
                    content = """
                    return .success(try self.dao.erase(byPrimaryKeys: \(persistingArgument.bodyName)))
                    """
                default:
                    content = """
                    return .success(try self.dao.erase(byPrimaryKey: \(persistingArgument.bodyName)))
                    """
                }
            } else {
                content = """
                return .success(try self.dao.erase())
                """
            }
        } else if annotations.contains(annotationName: "count") {
            content = """
            .success(try self.dao.count())
            """
        } else {
            content = "fatalError(\"service-autograph cannot define what to do with current method\")"
        }
        return """
        createCall { () -> Result<\(payloadType), Error> in
        \(content.indent(3))
                }

        """
    }

    /// Composes network service call body
    /// - Parameters:
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    ///   - payloadType: return type
    ///   - annotations: current method annotations
    ///   - arguments: current method arguments
    ///   - cancelable: true if the given call is cancelable
    /// - Returns: network service call body
    private func composeNetworkServiceCallBody(
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters,
        payloadType: TypeSpecification,
        annotations: [AnnotationSpecification],
        arguments: [ArgumentSpecification],
        cancelable: Bool
    ) -> String {

        let jsonRequestParameters: (type: String, content: String)?

//        if arguments[0].type.verse == "UserPlainObject" {
//            print(arguments)
//            print(arguments[0].type.verse)
//            print(specifications.isEncodable(arguments[0].type.verse))
//        }

        if arguments.count == 1, specifications.isEncodable(arguments[0].type.verse) {
            jsonRequestParameters = composeEncodedRequestParameters(
                from: arguments[0].name,
                withType: "json"
            )
        } else {
            jsonRequestParameters = composeRequestParameters(
                from: arguments.annotatedWith("json"),
                withType: "json"
            )
        }

        let queryRequestParameters = composeRequestParameters(
            from: arguments.annotatedWith("query"),
            withType: "query"
        )

        let requestParameters = [jsonRequestParameters, queryRequestParameters].compactMap { $0 }
        let httpRequestInit = composeHTTPRequest(
            forSpecifications: specifications,
            withParameters: parameters,
            usingAnnotations: annotations,
            arguments: arguments
        )
        let daoStr = composeDAO(annotations: annotations, arguments: arguments)

        let successStr = cancelable
            ? cancelableSuccess(payloadType: payloadType, annotations: annotations)
            : success(payloadType: payloadType, annotations: annotations, daoStr: daoStr)

        if annotations.contains(annotationName: "url") {
            if cancelable {
                return cancelableServiceCallBody(
                    payloadType: payloadType.verse,
                    requestParameters: requestParameters,
                    httpRequestInit: httpRequestInit,
                    success: successStr
                )
            } else {
                return serviceCallBody(
                    payloadType: payloadType.verse,
                    requestParameters: requestParameters,
                    httpRequestInit: httpRequestInit,
                    success: successStr
                )
            }
        } else {
            return composeDAOServiceCallBody(
                payloadType,
                annotations: annotations,
                arguments: arguments
            )
        }
    }

    /// Composes implementation of the given method
    /// - Parameters:
    ///   - method: target method
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    /// - Throws: composition errors
    /// - Returns: implementation of the given method
    private func composeMethod(
        _ method: MethodSpecification,
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters
    ) throws -> MethodSpecification {

        guard let returnType = method.returnType else {
            throw XcodeMessage(
                declaration: method.declaration,
                message: "[service-autograph] Service method must return a ServiceCall<> or a CancelableServiceCall<>"
            )
        }

        let body: String

        let serviceReturnType = returnType.serviceCallReturnType
        switch serviceReturnType {
        case .error:
            throw XcodeMessage(
                declaration: method.declaration,
                message: "[service-autograph] Service method must return a ServiceCall<> or a CancelableServiceCall<>"
            )

        case .serviceCall(let payloadType):
            body = composeNetworkServiceCallBody(
                forSpecifications: specifications,
                withParameters: parameters,
                payloadType: payloadType,
                annotations: method.annotations,
                arguments: method.arguments,
                cancelable: false
            )

        case .cancelableServiceCall(let payloadType):
            body = composeNetworkServiceCallBody(
                forSpecifications: specifications,
                withParameters: parameters,
                payloadType: payloadType,
                annotations: method.annotations,
                arguments: method.arguments,
                cancelable: true
            )
        }

        return try .template(
            comment: method.comment,
            accessibility: method.accessibility,
            attributes: method.attributes,
            name: method.name,
            generics: method.generics,
            arguments: method.arguments,
            returnType: method.returnType,
            kind: .instance,
            body: body
        )
    }

    /// Composes implementations for some methods
    /// - Parameters:
    ///   - methods: some service methods
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    /// - Throws: composition errors
    /// - Returns: implementations for some methods
    private func composeMethods(
        _ methods: [MethodSpecification],
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters
    ) throws -> [MethodSpecification] {
        try methods.map {
            try composeMethod(
                $0,
                forSpecifications: specifications,
                withParameters: parameters
            )
        }
    }

    /// Composes generating class main body
    /// - Parameters:
    ///   - service: some service
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    /// - Throws: composition errors
    /// - Returns: generating class main body
    private func classBody(
        _ service: ServicePlainObject,
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters
    ) throws -> String {
        var classBody = ""
        let daoMethods = ["read", "persist", "create", "erase", "count"]
        let withDAO = service.methods.flatMap(\.annotations).contains { daoMethods.contains($0.name) }
        if withDAO {
            let declaredDAOName = specifications.protocols.first { $0.name == service.parentProtocol }?.annotations["dao"]?.value
            let daoName = declaredDAOName ?? service.name.components(separatedBy: "Service").first.unwrap()
            classBody = """

            // MARK: - Properties

            /// \(daoName)DAO instance
            private let dao: \(daoName)DAO

            /// Default initializer
            /// - Parameters:
            ///   - dao: \(daoName)DAO instance
            ///   - transport: HTTPTransport instance
            init(
                dao: \(daoName)DAO,
                transport: HTTPTransport
            ) {
                self.dao = dao
                super.init(transport: transport)
            }
            """
        }
        return classBody
    }

    /// Composes service implementation
    /// - Parameters:
    ///   - service: target service info
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    ///   - projectName: target project name
    /// - Throws: composition errors
    /// - Returns: service implementation
    private func composeService(
        _ service: ServicePlainObject,
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters,
        projectName: String
    ) throws -> AutographImplementation {

        let body = try classBody(
            service,
            forSpecifications: specifications,
            withParameters: parameters
        )

        let implementedMethods = try composeMethods(
            service.methods,
            forSpecifications: specifications,
            withParameters: parameters
        )

        let methodsStr = implementedMethods.isEmpty
            ? ""
            : implementedMethods.reduce("\n") { result, method in
                result + method.verse.indent + (implementedMethods.last == method ? "\n" : "\n\n")
            }

        let header = headerComment(
            filename: "\(service.name).swift",
            projectName: projectName,
            imports: ["HTTPTransport"]
        )

        let serviceEntityStr = service.isGroupService ? """

        /// Entity string value
        var serviceEntity: String {

        }

        """ : ""

        let serviceImplementation = """
        \(header)
        // MARK: - \(service.name)

        final class \(service.name): WebService {
            \(body.indent)
        }

        // MARK: - \(service.parentProtocol)

        extension \(service.name): \(service.parentProtocol) {
            \(serviceEntityStr.indent)\(methodsStr)

        }

        """.replacingOccurrences(of: "}\n\n\n}", with: "}\n}")
        return AutographImplementation(
            filePath: "\(service.destination)/\(service.name).swift",
            sourceCode: serviceImplementation
        )
    }

    /// Composes implementations for found service protocols
    /// - Parameters:
    ///   - specifications: Synopsis specifications of our parsed code
    ///   - parameters: curent execution parameters
    /// - Throws: composition errors
    /// - Returns: implementations for found service protocols
    private func composeServices(
        forSpecifications specifications: Specifications,
        withParameters parameters: AutographExecutionParameters
    ) throws -> [AutographImplementation] {
        let services = specifications.protocols.filter(\.isService).flatMap { service in
            service.serviceNames.map {
                ServicePlainObject(
                    comment: service.comment,
                    name: $0,
                    isGroupService: service.serviceNames.count > 1,
                    parentProtocol: service.name,
                    methods: service.methods,
                    destination: parameters[.output] ?? service.declaration.filePath.deletingLastPathComponent().absoluteString
                )
            }
        }
        guard let projectName = parameters[.projectName] else {
            throw ServiceAutographError.noProjectName
        }
        let implementations = try services.map {
            try composeService(
                $0,
                forSpecifications: specifications,
                withParameters: parameters,
                projectName: projectName
            )
        }
        return implementations
    }
}

// MARK: - ImplementationComposer

extension ServiceImplementationComposer: ImplementationComposer {

    public func compose(
        forSpecifications specifications: Specifications,
        parameters: AutographExecutionParameters
    ) throws -> [AutographImplementation] {
        let implementations = try composeServices(
            forSpecifications: specifications,
            withParameters: parameters
        )
        return implementations
    }
}
