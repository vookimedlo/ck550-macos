//
//  EvaluationSupport.swift
//  ck550-cli-dev
//
//  Created by Michal Duda on 13/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class EvaluationSupport {
    private var errors: [CLIError] = []
    
    var hasFailed: Bool {
        get {
            return !errors.isEmpty
        }
    }
    
    var failedResults: [CLIError] {
        get {
            return errors
        }
    }
    
    var firstFailure: CLIError? {
        get {
            return errors.first
        }
    }
    
    func evaluateColor(color: [Int]) -> CLIError {
        if !color.isEmpty {
            if color.count == 3 {
                for item in color {
                    if item < 0 || 255 < item {
                        errors.append(CLIError.colorOutOfRange(color[0], color[1], color[2]))
                        return errors.last!
                    }
                }
            }
            else {
                errors.append(CLIError.colorIncomplete(color))
                return errors.last!
            }
        }
        return CLIError.ok
    }

    func evaluateProfile(profileId: Int?) -> CLIError {
        if let profileId = profileId {
            if profileId < 1 || 4 < profileId {
                errors.append(CLIError.invalidProfileId(profileId))
                return errors.last!
            }
        }
        return CLIError.ok
    }
}
