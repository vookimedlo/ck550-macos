//
//  Logging.swift
//  ck550-cli
//
//  Created by Michal Duda on 26/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import os.log

#if DEBUG
private func inDebugSession() -> Bool {
    var info = kinfo_proc()
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout<kinfo_proc>.size(ofValue: info)
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
}

private let isDebugged: Bool = inDebugSession()
#endif

func logDebug(_ format: StaticString, _ args: CVarArg...) {
    #if DEBUG
    if isDebugged {
        os_log(format, type: .debug, args)
    }
    #endif
}

func logError(_ format: StaticString, _ args: CVarArg...) {
    os_log(format, type: .error, args)
}

func logInfo(_ format: StaticString, _ args: CVarArg...) {
    os_log(format, type: .info, args)
}
