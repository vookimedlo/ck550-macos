//
//  SingleKeyCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 13/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

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

    public let verb = "effect-single-key"
    public let function = "Set a single-key effect"

    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateColor(color: options.color)
        _ = evalSupport.evaluateColor(color: options.backgroundColor)
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }

        typealias CK550Speed = CK550Command.OffEffectSingleKeySpeed
        var speed: CK550Speed {
            switch options.speed {
            case .highest:
                return CK550Speed.Highest
            case .higher:
                return CK550Speed.Higher
            case .middle:
                return CK550Speed.Middle
            case .lower:
                return CK550Speed.Lower
            case .lowest:
                return CK550Speed.Lowest
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
