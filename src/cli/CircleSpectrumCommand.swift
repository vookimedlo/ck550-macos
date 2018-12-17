//
//  CircleSpectrumCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 14/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result
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
