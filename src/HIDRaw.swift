//
//  HIDRaw.swift
//  ck550
//
//  Created by Michal Duda on 10/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import IOKit

class HIDRaw {
    private let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    private var dispatchQueue = DispatchQueue(label: "HIDRaw", qos: .utility, attributes: .concurrent)
    private var usagePage: UInt32 = 0
    private var usage: UInt32 = 0
    
    
    private func enumerated(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        guard result == kIOReturnSuccess else {
            return
        }
        
        if (usagePage == 0 || usagePage == (IOHIDDeviceGetProperty(device, "PrimaryUsagePage" as CFString) as! UInt32)) && (usage == 0 || usage == (IOHIDDeviceGetProperty(device, "PrimaryUsage" as CFString) as! UInt32)) {
            
            print(device)
            print("keyboard device")
            
            let hidDevice = HIDDevice(manager: manager, device: device)
            hidDevice.open()
            /*
             _ = hidDevice.write(command: CK550Command.setProfileControl)
             _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 3))
             _ = hidDevice.write(command: CK550Command.setEffectControl)
             _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Static))
             
             _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
             _ = hidDevice.write(command: CK550Command.setFirmwareControl)
*/
            

            _ = hidDevice.write(command: CK550Command.setProfileControl)
            _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 3))
            _ = hidDevice.write(command: CK550Command.setEffectControl)
            _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Off))
            _ = hidDevice.write(command: CK550Command.setCustomizationRGBControl)
            _ = hidDevice.write(command: CK550Command.settmp2)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping0)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping1)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping2)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping3)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping4)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping5)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping6)
            _ = hidDevice.write(command: CK550Command.setCustomRGBMapping7)
            _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Off))
            _ = hidDevice.write(command: CK550Command.settmp3)

            
//            _ = hidDevice.write(command: CK550Command.setLEDColor(key: 0x2e, red: 0x2F, green: 0x4F, blue: 0x4F))
//            _ = hidDevice.write(command: CK550Command.saveCurrentProfile)

//            _ = hidDevice.write(command: CK550Command.setFirmwareControl)

  //          _ = hidDevice.write(command: CK550Command.setProfileControl)
    //        _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 3))
      //      _ = hidDevice.write(command: CK550Command.setEffectControl)
        //    _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Customization))
          //  _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
         //   _ = hidDevice.write(command: CK550Command.setFirmwareControl)
            
  //          _ = hidDevice.write(command: CK550Command.setProfileControl)
//            _ = hidDevice.write(command: CK550Command.getFirmwareVersion)
            
  //          _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 3))
//        _ = hidDevice.write(command: CK550Command.turnLEDsOff)
///            _ = hidDevice.write(command: CK550Command.setManualControl)
 //           _ = hidDevice.write(command: CK550Command.setManualControl2)

 //           _ = hidDevice.write(command: CK550Command.setLEDsColor(red: 0x2F, green: 0x4F, blue: 0x4F))
 //           _ = hidDevice.write(command: CK550Command.setEffectControl)
  //          _ = hidDevice.write(command: CK550Command.setEffect(effectId: 4))
   //         _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
      //      let res = hidDevice.write(command: CK550Command.setFirmwareControl)
   //         _ = hidDevice.write(command: CK550Command.setLEDColor(key: 0x02, red: 0x00, green: 0x00, blue: 0xFF))
     //       _ = hidDevice.write(command: CK550Command.setEffectControl)
        //    _ = hidDevice.write(command: CK550Command.setEffect(effectId: 0))

       //     _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
         //   let res = hidDevice.write(command: CK550Command.setFirmwareControl)
   //         print("write", res)
        }
    }
    
    private func removed(result: IOReturn, sender: UnsafeMutableRawPointer, device: IOHIDDevice!) -> Void {
        print("disconnect")
        print(result)
    }
    
    func monitorEnumeration(vid: Int, pid: Int) -> Bool {
        return monitorEnumeration(vid: vid, pid: pid, usagePage: 0, usage: 0)
    }
    
    func monitorEnumeration(vid: Int, pid: Int, usagePage: UInt32, usage: UInt32) -> Bool {
        let deviceMatch = [kIOHIDProductIDKey: pid, kIOHIDVendorIDKey: vid]
        self.usagePage = usagePage
        self.usage = usage
        
        let matchingCallback : IOHIDDeviceCallback = { context, result, sender, device in
            let this : HIDRaw = Unmanaged<HIDRaw>.fromOpaque(context!).takeUnretainedValue()
            this.enumerated(result: result, sender: sender!, device: device)
        }
        
        let removalCallback : IOHIDDeviceCallback = { context, result, sender, device in
           let this : HIDRaw = Unmanaged<HIDRaw>.fromOpaque(context!).takeUnretainedValue()
            this.removed(result: result, sender: sender!, device: device)
        }
        
        let this = Unmanaged.passRetained(self).toOpaque()
        IOHIDManagerRegisterDeviceMatchingCallback(manager, matchingCallback, this)
        IOHIDManagerRegisterDeviceRemovalCallback(manager, removalCallback, this)
        
        IOHIDManagerSetDeviceMatching(manager, deviceMatch as CFDictionary?)
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        return kIOReturnSuccess == IOHIDManagerOpen(manager, 0)
    }

}
