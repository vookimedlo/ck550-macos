//
//  ColorCycleCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 12/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result
import Curry

public struct ColorCycleCommand: CommandProtocol {
    public struct Options: OptionsProtocol {
        public let profileId: Int
        public let speed: SpeedArgument
        
        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                <*> mode <| Option(key: "profile", defaultValue: 0, usage: "keyboard profile to use for a modification")
                <*> mode <| Option(key: "speed", defaultValue: .middle, usage: "effect speed (one of 'highest', 'higher', 'middle', 'lower', or 'lowest'), by default 'middle'")
        }
    }
    
    public let verb = "effect-color-cycle"
    public let function = "Set a color-cycle effect"
    
    public func run(_ options: Options) -> Result<(), CLIError> {
        let cli = CLI()

        typealias CK550Speed = CK550Command.OffEffectColorCycleSpeed
        var speed: CK550Speed {
            switch options.speed {
            case .highest:
                return CK550Speed.Highest
            case .higher:
                return  CK550Speed.Higher
            case .middle:
                return CK550Speed.Middle
            case .lower:
                return CK550Speed.Lower
            case .lowest:
                return CK550Speed.Lowest
            }
        }
        
        cli.onOpen {
            var result : Bool = true
            
            if 1 <= options.profileId && options.profileId <= 4 {
                result = cli.setProfile(profileId: UInt8(options.profileId))
            }
            
            if result {
                cli.setOffEffectColorCycle(speed: speed)
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
