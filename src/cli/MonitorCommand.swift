//
//  LoopCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 12/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct MonitorCommand: CommandProtocol {
    public let verb = "monitor"
    public let function = "Monitor HID devices continuously to see changes on an USB bus"
    
    public func run(_ options: NoOptions<CLIError>) -> Result<(), CLIError> {
        let cli = CLI()
        
        if cli.startHIDMonitoring() {
            Terminal.general(" - Monitoring HID ...")
            RunLoop.current.run()
        }

        return .success(())
    }
}
