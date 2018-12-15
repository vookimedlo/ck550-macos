//
//  WaveCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 14/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

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
        
        public static let name = "wave-direction"
        
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
    
    public let verb = "effect-wave"
    public let function = "Set a wave effect"
    
    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateColor(color: options.color)
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }
        
        typealias CK550Speed = CK550Command.OffEffectWaveSpeed
        var speed: CK550Speed {
            switch options.speed {
            case .highest: return CK550Speed.Highest
            case .higher:  return CK550Speed.Higher
            case .middle:  return CK550Speed.Middle
            case .lower:   return CK550Speed.Lower
            case .lowest:  return CK550Speed.Lowest
            }
        }
        
        typealias WaveDirection = CK550Command.OffEffectWaveDirection
        var direction: WaveDirection {
            switch options.direction {
            case .bottomToTop: return WaveDirection.BottomToTop
            case .leftToRight: return WaveDirection.LeftToRight
            case .rightToLeft: return WaveDirection.RightToLeft
            case .topToBottom: return WaveDirection.TopToBottom
            }
        }
        
        let cli = CLI()
        cli.onOpen {
            var result : Bool = true
            
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
