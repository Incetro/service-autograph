//
//  ProtocolSpecification.swift
//  service-autograph
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis

// MARK: - ProtocolSpecification

extension ProtocolSpecification {

    var isService: Bool {
        annotations.contains(annotationName: "service")
    }

    var serviceNames: [String] {
        (annotations["service"]?.value ?? name).components(separatedBy: "/").map {
            $0 + "GeneratedImplementation"
        }
    }
}
