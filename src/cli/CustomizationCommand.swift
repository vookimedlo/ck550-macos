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

    public let verb = "effect-custom"
    public let function = "Set a custom color for individual keys"

    public func run(_ options: Options) -> Result<(), CLIError> {
        let cli = CLI()

        cli.onOpen {
            var result: Bool = true

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
