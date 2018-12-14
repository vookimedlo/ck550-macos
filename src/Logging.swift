//
//  Logging.swift
//  ck550-cli
//
//  Created by Michal Duda on 26/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import os.log

func LogDebug(_ format: StaticString, _ args: CVarArg...) {
    #if DEBUG
    os_log(format, type: .debug, args)
    #endif
}

func LogError(_ format: StaticString, _ args: CVarArg...) {
    os_log(format, type: .error, args)
}

func LogInfo(_ format: StaticString, _ args: CVarArg...) {
    os_log(format, type: .info, args)
}
