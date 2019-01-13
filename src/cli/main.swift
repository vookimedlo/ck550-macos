/*

Licensed under the MIT license:

Copyright (c) 2019 Michal Duda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import Foundation
import Commandant
import Result

/// Errors related to the CLI arguments.
///
/// - ok: Argument was proccessed successfully.
/// - colorOutOfRange: Specified color has a component greater than 255.
/// - colorIncomplete: Specified color has not all components.
/// - invalidProfileId: Wrong (Out of range) profile ID.
public enum CLIError: Error {
// swiftlint:disable identifier_name
    case ok
// swiftlint:enable identifier_name
    case colorOutOfRange(Int, Int, Int)
    case colorIncomplete([Int])
    case invalidProfileId(Int)

    var description: String {
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

Terminal.important("-= CK550 MacOS Utility =-")

/// All available CLI arguments.
let registry = CommandRegistry<CLIError>()
registry.register(MonitorCommand())
registry.register(VersionCommand())
registry.register(LicenseCommand())
registry.register(ComponentsCommand())

// effects
registry.register(BreathingCommand())
registry.register(CircleSpectrumCommand())
registry.register(ColorCycleCommand())
registry.register(CrosshairCommand())
registry.register(CustomizationCommand())
registry.register(FireballCommand())
registry.register(HeartbeatCommand())
registry.register(OffCommand())
registry.register(ReactivePunchCommand())
registry.register(ReactiveTornadoCommand())
registry.register(RippleCommand())
registry.register(SingleKeyCommand())
registry.register(SnowingCommand())
registry.register(StarsCommand())
registry.register(StaticCommand())
registry.register(WaterRippleCommand())
registry.register(WaveCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    Terminal.error(error.description)
}
