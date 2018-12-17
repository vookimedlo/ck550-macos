//
//  BreathingCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 12/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result
import Curry

public struct BreathingCommand: CommandProtocol {
    public struct Options: OptionsProtocol {
        public let profileId: Int?
        public let speed: SpeedArgument
        public let color: [Int]

        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                    <*> mode <| Option(key: "profile", defaultValue: nil, usage: "keyboard profile to use for a modification")
                    <*> mode <| Option(key: "speed", defaultValue: .middle, usage: "effect speed (one of 'highest', 'higher', 'middle', 'lower', or 'lowest'), by default 'middle'")
                    <*> mode <| Option(key: "color", defaultValue: CommonColors.random.command(), usage: "color (format: --color \"255, 255, 255\"), by default the color is random")
        }
    }

    public let verb = "effect-breathing"
    public let function = "Set a breathing effect"

    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateColor(color: options.color)
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }

        typealias CK550Speed = CK550Command.OffEffectOverride.Breathing.Speed
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
                cli.setOffEffectBreathing(speed: speed, color: createRGBColor(options.color))
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
