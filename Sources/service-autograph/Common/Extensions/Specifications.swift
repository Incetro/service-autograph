//
//  Specifications.swift
//  service-autograph
//
//  Created by incetro on 4/4/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis

// MARK: - Specifications

extension Specifications {

    func isDecodable(_ name: String) -> Bool {
        if let structure = structures.named(name) {
            let isInherited = structure.inheritedTypes.contains("Codable") || structure.inheritedTypes.contains("Decodable")
            let isExtensionInherited = consolidatedStructures[structure]?.first {
                $0.inheritedTypes.contains("Codable") || $0.inheritedTypes.contains("Decodable")
            } != nil
            return isInherited || isExtensionInherited
        }
        if let `class` = classes.named(name) {
            let isInherited = `class`.inheritedTypes.contains("Codable") || `class`.inheritedTypes.contains("Decodable")
            let isExtensionInherited = consolidatedClasses[`class`]?.first {
                $0.inheritedTypes.contains("Codable") || $0.inheritedTypes.contains("Decodable")
            } != nil
            return isInherited || isExtensionInherited
        }
        return false
    }

    func isEncodable(_ name: String) -> Bool {
        if let structure = structures.named(name) {
            let isInherited = structure.inheritedTypes.contains("Codable") || structure.inheritedTypes.contains("Encodable")
            let isExtensionInherited = consolidatedStructures[structure]?.first {
                $0.inheritedTypes.contains("Codable") || $0.inheritedTypes.contains("Encodable")
            } != nil
            return isInherited || isExtensionInherited
        }
        if let `class` = classes.named(name) {
            let isInherited = `class`.inheritedTypes.contains("Codable") || `class`.inheritedTypes.contains("Encodable")
            let isExtensionInherited = consolidatedClasses[`class`]?.first {
                $0.inheritedTypes.contains("Codable") || $0.inheritedTypes.contains("Encodable")
            } != nil
            return isInherited || isExtensionInherited
        }
        return false
    }
}
