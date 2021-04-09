//
//  ServiceAutographApplication.swift
//  service-autograph
//
//  Created by incetro on 3/26/21.
//  Copyright © 2021 Incetro Inc. All rights reserved.
//

import Autograph

// MARK: - ServiceAutographApplication

final class ServiceAutographApplication: AutographApplication<ServiceImplementationComposer, ServiceInputFoldersProvider> {

    override func printHelp() {
        super.printHelp()
        print(
            """
            -plains <directory>
            Path to the folder, where plain objects to be processed are stored.
            If not set, current working directory is used by default.

            -services <directory>
            Input folder with service protocols.
            If not set, current working directory is used as an input folder.

            -output <directory>
            Where to put generated files.
            If not set, service's protocols paths is used instead.
            """
        )
    }
}
