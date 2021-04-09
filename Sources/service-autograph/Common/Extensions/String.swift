//
//  String.swift
//  service-autograph
//
//  Created by incetro on 3/30/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Synopsis

// MARK: - String

extension String {

    var adjust: String {
        self
            .components(separatedBy: "\n")
            .enumerated()
            .map { $0.offset == 0 ? $0.element : $0.element.isEmpty ? $0.element : "    " + $0.element }
            .joined(separator: "\n")
    }

    func adjust(_ count: Int) -> String {
        var result = self
        for _ in 0..<count {
            result = result.adjust
        }
        return result
    }

    func indent(_ count: Int) -> String {
        var result = self
        for _ in 0..<count {
            result = result.indent
        }
        return result
    }
}
