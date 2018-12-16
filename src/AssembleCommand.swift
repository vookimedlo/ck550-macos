//
//  AssembleCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 09/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class AssembleCommand {
    enum AssembleError: Error {
        case FileReadFailure(path: String)
        case InvalidFormatJSON
        case UnknownError
    }
}




