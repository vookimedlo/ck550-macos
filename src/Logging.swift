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
import os.log

#if DEBUG
/// Evaluates if the process is being debugged.
///
/// - Returns: True if the process is attached to the debugger. False otherwise.
private func inDebugSession() -> Bool {
    var info = kinfo_proc()
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout<kinfo_proc>.size(ofValue: info)
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
}

/// Flag containing a result of `inDebugSession` evaluation during a startup.
private let isDebugged: Bool = inDebugSession()
#endif

/// Sends a message to the logging system with a debug severity.
///
/// - Parameters:
///   - format: A constant string or format string that produces a human-readable log message.
///   - args: If message is a constant string, do not specify arguments.
///           If message is a format string, pass the expected number of arguments
///           in the order that they appear in the string.
/// - Warning: Message is discarded if the app is not built in a *Debug* configuration.
func logDebug(_ format: StaticString, _ args: CVarArg...) {
    #if DEBUG
    if isDebugged {
        os_log(format, type: .debug, args)
    }
    #endif
}

/// Sends a message to the logging system with an error severity.
///
/// - Parameters:
///   - format: A constant string or format string that produces a human-readable log message.
///   - args: If message is a constant string, do not specify arguments.
///           If message is a format string, pass the expected number of arguments
///           in the order that they appear in the string.
func logError(_ format: StaticString, _ args: CVarArg...) {
    os_log(format, type: .error, args)
}

/// Sends a message to the logging system with an info severity.
///
/// - Parameters:
///   - format: A constant string or format string that produces a human-readable log message.
///   - args: If message is a constant string, do not specify arguments.
///           If message is a format string, pass the expected number of arguments
///           in the order that they appear in the string.
func logInfo(_ format: StaticString, _ args: CVarArg...) {
    os_log(format, type: .info, args)
}
