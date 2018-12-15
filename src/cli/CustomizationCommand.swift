//
//  CustomizationCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 12/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result
import Curry

public struct CustomizationCommand: CommandProtocol {
    public struct Options: OptionsProtocol {
        public let profileId: Int
        public let configurationPath: String

        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                <*> mode <| Option(key: "profile", defaultValue: 0, usage: "keyboard profile to use for a modification")
                <*> mode <| Argument(usage: "the configuration file describing individual key colors")
        }
    }
    
    public let verb = "effect-customization"
    public let function = "Set a custom color for individual keys"
    
    public func run(_ options: Options) -> Result<(), CLIError> {
        let cli = CLI()
        
        cli.onOpen {
            var result : Bool = true
            
            if 1 <= options.profileId && options.profileId <= 4 {
                result = cli.setProfile(profileId: UInt8(options.profileId))
            }
            
            if result {
                cli.setCustomColors(jsonPath: options.configurationPath)
            }
            
            DispatchQueue.main.async {
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
        
        if cli.startHIDMonitoring() {
            Terminal.general(" - Monitoring HID ...")
            CFRunLoopRun()
        }

        Terminal.important(" - Quitting ... Bye, Bye")
        return .success(())
    }
}
