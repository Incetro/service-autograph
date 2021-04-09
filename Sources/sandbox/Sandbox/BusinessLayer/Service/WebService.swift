//
//  WebService.swift
//  Sandbox
//
//  Created by incetro on 3/21/20.
//  Copyright © 2020 Incetro Inc. All rights reserved.
//

import HTTPTransport

// MARK: - WebService

class WebService: Service {

    /// Web service root
    let baseURL: URL

    /// Default request headers
    let headers: [String: String]

    /// Request interceptors for all requests.
    let requestInterceptors: [HTTPRequestInterceptor]

    /// Response interceptors for all requests.
    let responseInterceptors: [HTTPResponseInterceptor]

    /// Base request
    var baseRequest: HTTPRequest {
        HTTPRequest(
            endpoint: baseURL.absoluteString,
            headers: headers,
            requestInterceptors: requestInterceptors,
            responseInterceptors: responseInterceptors
        )
    }

    /// Transport for requests
    let transport: HTTPTransport

    /// Empty JSON parameters
    var jsonParameters: HTTPRequestParameters {
        HTTPRequestParameters(parameters: [:], encoding: HTTPRequestParameters.Encoding.json)
    }

    /// Empty URL parameters
    var queryParameters: HTTPRequestParameters {
        HTTPRequestParameters(parameters: [:], encoding: HTTPRequestParameters.Encoding.url)
    }

    /// Default initializer
    /// - Parameters:
    ///   - operationQueue: background working queue
    ///   - completionQueue: main queue for callbacks
    ///   - baseURL: base url address
    ///   - transport: Transport for requests
    ///   - requestInterceptors: request interceptors
    ///   - responseInterceptors: response interceptors
    ///   - headers: default request headers
    init(
        operationQueue: OperationQueue = OperationQueue(),
        completionQueue: OperationQueue = OperationQueue.main,
        baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com").unsafelyUnwrapped,
        transport: HTTPTransport,
        requestInterceptors: [HTTPRequestInterceptor] = [],
        responseInterceptors: [HTTPResponseInterceptor] = [],
        headers: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.transport = transport
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
        self.headers = headers
        super.init(operationQueue: operationQueue, completionQueue: completionQueue)
    }

    /// Allowing to fill HTTPRequestParameters with optional values
    func fillHTTPRequestParameters(
        _ httpRequestParameters: HTTPRequestParameters,
        with parameters: [String: Any?]
    ) -> HTTPRequestParameters {
        parameters.forEach { (parameter: (name: String, value: Any?)) in
            if let value: Any = parameter.value {
                httpRequestParameters[parameter.name] = value
            }
        }
        return httpRequestParameters
    }
}
