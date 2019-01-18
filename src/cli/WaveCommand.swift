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
import Curry

public struct WaveCommand: CommandProtocol {
    public enum WaveDirectionArgument: String, ArgumentProtocol, CustomStringConvertible {
        case leftToRight = "left-to-right"
        case topToBottom = "top-to-bottom"
        case rightToLeft = "right-to-left"
        case bottomToTop = "bottom-to-top"

        public var description: String {
            return self.rawValue
        }

        public static let name = "rainbow-wave-direction"

        public static func from(string: String) -> WaveDirectionArgument? {
            return self.init(rawValue: string.lowercased())
        }
    }

    public struct Options: OptionsProtocol {
        public let profileId: Int?
        public let speed: SpeedArgument
        public let direction: WaveDirectionArgument
        public let color: [Int]

        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                    <*> mode <| Option(key: "profile", defaultValue: nil, usage: "keyboard profile to use for a modification")
                    <*> mode <| Option(key: "speed", defaultValue: .middle, usage: "effect speed (one of 'highest', 'higher', 'middle', 'lower', or 'lowest'), by default 'middle'")
                    <*> mode <| Option(key: "direction", defaultValue: .leftToRight, usage: "effect direction (one of 'left-to-right', 'top-to-bottom', 'right-to-left', or 'bottom-to-top'), by default 'left-to-right'")
                    <*> mode <| Option(key: "color", defaultValue: CommonColors.white.command(), usage: "color (format: --color \"255, 255, 255\"), by default the color is white")
        }
    }

    public let verb = "effect-rainbow-wave"
    public let function = "Set a rainbow-wave effect"

    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateColor(color: options.color)
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }

        typealias CK550Speed = CK550Command.OffEffectOverride.Wave.Speed
        var speed: CK550Speed {
            switch options.speed {
            case .highest: return CK550Speed.highest
            case .higher:  return CK550Speed.higher
            case .middle:  return CK550Speed.middle
            case .lower:   return CK550Speed.lower
            case .lowest:  return CK550Speed.lowest
            }
        }

        typealias WaveDirection = CK550Command.OffEffectOverride.Wave.Direction
        var direction: WaveDirection {
            switch options.direction {
            case .bottomToTop: return WaveDirection.bottomToTop
            case .leftToRight: return WaveDirection.leftToRight
            case .rightToLeft: return WaveDirection.rightToLeft
            case .topToBottom: return WaveDirection.topToBottom
            }
        }

        let cli = CLI()
        cli.onOpen {
            var result: Bool = true

            if let profileId = options.profileId {
                result = cli.setProfile(profileId: UInt8(profileId))
            }

            if result {
                cli.setOffEffectWave(color: createRGBColor(options.color)!, direction: direction, speed: speed)
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
