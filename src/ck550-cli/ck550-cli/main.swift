//
//  main.swift
//  ck550-cli
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

print("Hello, World!")

let hid = HIDRaw()

var layout = CK550CustomizationLayoutUS()
var custom = CK550CustomizationKeys(layout: layout)

layout.setColor(key: .Numeric1, color: RGBColor(red: 0xFE, green: 0xFD, blue: 0xFC))

let packets = custom.packets()
print(Data(packets[1]).hexString())


var boolResult = hid.monitorEnumeration(vid: 0x2516, pid: 0x007f, usagePage: 0xFF00, usage: 0x00)
print("monitoring...", boolResult)

RunLoop.current.run()
