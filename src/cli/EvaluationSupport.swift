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

class EvaluationSupport {
    private var errors: [CLIError] = []

    var hasFailed: Bool {
        return !errors.isEmpty
    }
    var failedResults: [CLIError] {
        return errors
    }

    var firstFailure: CLIError? {
        return errors.first
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
            } else {
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
