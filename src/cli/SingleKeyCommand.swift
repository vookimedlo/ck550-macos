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

public struct SingleKeyCommand: CommandProtocol {
    public struct Options: OptionsProtocol {
        public let profileId: Int?
        public let speed: SpeedArgument
        public let color: [Int]
        public let backgroundColor: [Int]

        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                    <*> mode <| Option(key: "profile", defaultValue: nil, usage: "keyboard profile to use for a modification")
                    <*> mode <| Option(key: "speed", defaultValue: .middle, usage: "effect speed (one of 'highest', 'higher', 'middle', 'lower', or 'lowest'), by default 'middle'")
                    <*> mode <| Option(key: "color", defaultValue: CommonColors.white.command(), usage: "color (format: --color \"255, 255, 255\"), by default the color is white")
                    <*> mode <| Option(key: "background-color", defaultValue: CommonColors.black.command(), usage: "background color (format: --background-color \"255, 255, 255\"), by default the color is black")
        }
    }

    public let verb = "effect-reactive-fade"
    public let function = "Set a reactive-fade effect"

    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateColor(color: options.color)
        _ = evalSupport.evaluateColor(color: options.backgroundColor)
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }

        typealias CK550Speed = CK550Command.OffEffectOverride.SingleKey.Speed
        var speed: CK550Speed {
            switch options.speed {
            case .highest:
                return CK550Speed.highest
            case .higher:
                return CK550Speed.higher
            case .middle:
                return CK550Speed.middle
            case .lower:
                return CK550Speed.lower
            case .lowest:
                return CK550Speed.lowest
            }
        }

        let cli = CLI()
        cli.onOpen {
            var result: Bool = true

            if let profileId = options.profileId {
                result = cli.setProfile(profileId: UInt8(profileId))
            }

            if result {
                cli.setOffEffectSingleKey(background: createRGBColor(options.backgroundColor)!, key: createRGBColor(options.color)!, speed: speed)
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
