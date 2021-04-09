//
//  Array.swift
//  service-autograph
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Foundation

// MARK: - Array

extension Array where Element == String {

    var dictString: String {
        if isEmpty {
            return ":"
        }
        return joined(separator: ",\n")
    }
}
