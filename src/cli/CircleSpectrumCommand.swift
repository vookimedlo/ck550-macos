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
import Curry

public struct CircleSpectrumCommand: CommandProtocol {
    public enum CircleSpectrumDirectionArgument: String, ArgumentProtocol, CustomStringConvertible {
        case clockwise
        case counterclockwise

        public var description: String {
            return self.rawValue
        }

        public static let name = "circle-spectrum-direction"

        public static func from(string: String) -> CircleSpectrumDirectionArgument? {
            return self.init(rawValue: string.lowercased())
        }
    }

    public struct Options: OptionsProtocol {
        public let profileId: Int?
        public let speed: SpeedArgument
        public let direction: CircleSpectrumDirectionArgument

        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                    <*> mode <| Option(key: "profile", defaultValue: nil, usage: "keyboard profile to use for a modification")
                    <*> mode <| Option(key: "speed", defaultValue: .middle, usage: "effect speed (one of 'highest', 'higher', 'middle', 'lower', or 'lowest'), by default 'middle'")
                    <*> mode <| Option(key: "direction", defaultValue: .clockwise, usage: "effect direction (one of 'clockwise', or 'counterclockwise'")
        }
    }

    public let verb = "effect-circle-spectrum"
    public let function = "Set a circle spectrum effect"

    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }

        typealias CK550Speed = CK550Command.OffEffectOverride.CircleSpectrum.Speed
        var speed: CK550Speed {
            switch options.speed {
            case .highest: return CK550Speed.highest
            case .higher:  return CK550Speed.higher
            case .middle:  return CK550Speed.middle
            case .lower:   return CK550Speed.lower
            case .lowest:  return CK550Speed.lowest
            }
        }

        typealias CircleSpectrumDirection = CK550Command.OffEffectOverride.CircleSpectrum.Direction
        var direction: CircleSpectrumDirection {
            switch options.direction {
            case .clockwise: return CircleSpectrumDirection.clockwise
            case .counterclockwise: return CircleSpectrumDirection.counterclockwise
            }
        }

        let cli = CLI()
        cli.onOpen {
            var result: Bool = true

            if let profileId = options.profileId {
                result = cli.setProfile(profileId: UInt8(profileId))
            }

            if result {
                cli.setOffEffectCircleSpectrum(speed: speed, direction: direction)
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
