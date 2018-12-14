//
//  VersionCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 12/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct VersionCommand: CommandProtocol {
    public let verb = "version"
    public let function = "Display the current ck550-cli version"
    
    public func run(_ options: NoOptions<CLIError>) -> Result<(), CLIError> {
        Terminal.general("TODO: yyyy.mm.dd")
        return .success(())
    }
}
