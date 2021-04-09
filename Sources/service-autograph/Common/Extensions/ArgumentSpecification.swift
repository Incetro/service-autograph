//
//  ArgumentSpecification.swift
//  service-autograph
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis

// MARK: - ArgumentSpecification

extension ArgumentSpecification {

    func annotationValue(_ annotationName: String) -> String? {
        if let annotation = annotations[annotationName] {
            return annotation.value ?? bodyName
        }
        return nil
    }

    var urlPlaceholderName: String? {
        if let urlAnnotation = annotations["url"] {
            return urlAnnotation.value ?? bodyName
        }
        return nil
    }
}

extension Sequence where Element == ArgumentSpecification {

    func annotatedWith(_ annotationName: String) -> [String] {
        compactMap { argument in
            if let annotationValue = argument.annotationValue(annotationName) {
                return "\"\(annotationValue)\": \"\\(\(argument.bodyName))\""
            }
            return nil
        }
    }
}
