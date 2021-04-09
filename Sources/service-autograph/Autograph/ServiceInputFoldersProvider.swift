//
//  ServiceInputFoldersProvider.swift
//  service-autograph
//
//  Created by incetro on 3/26/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Autograph

// MARK: - ServiceInputFoldersProvider

public final class ServiceInputFoldersProvider {

    public init() {
    }
}

// MARK: - InputFoldersProvider

extension ServiceInputFoldersProvider: InputFoldersProvider {

    public func inputFoldersList(fromParameters parameters: AutographExecutionParameters) throws -> [String] {
        var inputFolders: [String] = []
        guard let servicesFolder = parameters[.services] else {
            throw ServiceAutographError.noServicesFolder
        }
        inputFolders.append(servicesFolder)
        if let plainsFolder = parameters[.plains] {
            inputFolders.append(plainsFolder)
        }
        return inputFolders
    }

    public func ephemeralFoldersList(fromParameters parameters: AutographExecutionParameters) throws -> [String] {
        guard let servicesFolder = parameters[.services] else {
            throw ServiceAutographError.noServicesFolder
        }
        return [servicesFolder]
    }
}
