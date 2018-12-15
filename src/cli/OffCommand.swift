//
//  OffCommand.swift
//  ck550-cli
//
//  Created by Michal Duda on 14/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Commandant
import Result
import Curry

public struct OffCommand: CommandProtocol {
    public struct Options: OptionsProtocol {
        public let profileId: Int?
        
        public static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<CLIError>> {
            return curry(self.init)
                <*> mode <| Option(key: "profile", defaultValue: nil, usage: "keyboard profile to use for a modification")
        }
    }
    
    public let verb = "effect-off"
    public let function = "Set an off effect"
    
    public func run(_ options: Options) -> Result<(), CLIError> {
        let evalSupport = EvaluationSupport()
        _ = evalSupport.evaluateProfile(profileId: options.profileId)
        if evalSupport.hasFailed {
            return .failure(evalSupport.firstFailure!)
        }
        
        let cli = CLI()
        cli.onOpen {
            var result : Bool = true
            
            if let profileId = options.profileId {
                result = cli.setProfile(profileId: UInt8(profileId))
            }
            
            if result {
                cli.setOffEffectOff()
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
