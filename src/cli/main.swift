//
//  main.swift
//  ck550-cli
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result

public enum CLIError: Error {
    case ok
    case colorOutOfRange(Int, Int, Int)
    case colorIncomplete([Int])
    case invalidProfileId(Int)
    
    var description: String {
        get {
            switch self {
            case .ok:
                return "OK"
            case .colorOutOfRange(let red, let green, let blue):
                return "Color [\(red), \(green), \(blue)] out of valid range"
            case .colorIncomplete(let array):
                return "Incomplete color \(array)"
            case .invalidProfileId(let profileId):
                return "Invalid profile \(profileId)"
            }
        }
    }
}

Terminal.important("-= CK550 MacOS Utility =-")

let monitorCommand = MonitorCommand()
let registry = CommandRegistry<CLIError>()
registry.register(monitorCommand)
registry.register(VersionCommand())

// effects
registry.register(BreathingCommand())
registry.register(CircleSpectrumCommand())
registry.register(ColorCycleCommand())
registry.register(CustomizationCommand())
registry.register(OffCommand())
registry.register(ReactiveTornadoCommand())
registry.register(RippleCommand())
registry.register(SingleKeyCommand())
registry.register(SnowingCommand())
registry.register(StarsCommand())
registry.register(StaticCommand())
registry.register(WaveCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
     Terminal.error(error.description)
}
