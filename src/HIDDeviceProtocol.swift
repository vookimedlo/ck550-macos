//
//  HIDDeviceProtocol.swift
//  ck550-cli
//
//  Created by Michal Duda on 27/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

protocol HIDDeviceProtocol {
    var manufacturer: String? { get }
    var product: String? { get }
    var vendorID: UInt32 { get }
    var productID: UInt32 { get }
    var usagePage: UInt32 { get }
    var usage: UInt32 { get }

    init(manager: IOHIDManager, device: IOHIDDevice)
    func open(options: IOOptionBits) -> Bool
    func close(options: IOOptionBits) -> Bool
    func dataReceived(buffer: [uint8])
    func write(command: [uint8]) -> Bool
}
