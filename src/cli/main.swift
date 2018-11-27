//
//  main.swift
//  ck550-cli
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class CLI: NSObject, HIDDeviceEnumeratedHandler {
    private let dispatchQueue = DispatchQueue(label: "cli", qos: .utility, attributes: .concurrent)
    private let hid = HIDRaw()
    private var hidDevice: HIDDevice? = nil
    
    
    override init() {
        super.init()
        startObserving()
        let boolResult = hid.monitorEnumeration(vid: 0x2516, pid: 0x007f, usagePage: 0xFF00, usage: 0x00)
        print("monitoring HID...", boolResult)
    }
    
    deinit {
        stopObserving()
    }
    
    func deviceEnumerated(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceEnumerated else {return}
        
        let hidDevice = notification.userInfo?["device"] as! HIDDevice
        LogDebug("Enumerated device: %@", hidDevice.manufacturer!, hidDevice.product!)
        _ = open(hidDevice: hidDevice)
    }
    
    func deviceRemoved(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceRemoved else {return}
        
        let hidDevice = notification.userInfo?["device"] as! HIDDevice
        LogDebug("Removed device: %@", hidDevice.manufacturer!, hidDevice.product!)
    }
    
    func open(hidDevice: HIDDevice) -> Bool {
        guard hidDevice.open() else {
            return false
        }
        self.hidDevice = hidDevice
        
        // TODO: move
        setProfile(profileId: 3)
        setEffect()
      //  saveCurrentProfile()
      //  setFirmwareControl()
        
        return true
    }
    
    func setEffect() -> Void {
        if let hidDevice = self.hidDevice {
            _ = hidDevice.write(command: CK550Command.setEffectControl)
            _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Static))
        }
    }
    
    func setProfile(profileId: uint8) -> Void {
        if let hidDevice = self.hidDevice {
            _ = hidDevice.write(command: CK550Command.setProfileControl)
            _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: profileId))
        }
    }
    
    func saveCurrentProfile() -> Void {
        if let hidDevice = self.hidDevice {
            _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
        }
    }

    func setFirmwareControl() -> Void {
        if let hidDevice = self.hidDevice {
            _ = hidDevice.write(command: CK550Command.setFirmwareControl)
        }
    }

    func setCustomColors() -> Void {
        if let hidDevice = self.hidDevice {
            // Changing the color of keys in Off effect
            let layout = CK550CustomizationLayoutUS()
            let custom = CK550CustomizationKeys(layout: layout)
            
            layout.setColor(key: .Numlock, color: RGBColor(red: 0x00, green: 0xFD, blue: 0xFC))
            layout.setColor(key: .Space, color: RGBColor(red: 0xFF, green: 0x00, blue: 0xFC))
            layout.setColor(key: .Escape, color: RGBColor(red: 0xFF, green: 0x00, blue: 0xFC))
            
            _ = hidDevice.write(command: CK550Command.setProfileControl)
            _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 3))
            _ = hidDevice.write(command: CK550Command.setEffectControl)
            _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Off))
            _ = hidDevice.write(command: CK550Command.setCustomizationRGBControl)
            _ = hidDevice.write(command: CK550Command.setCustomizationRGBControlUNKNOWN_BEFORE_PACKETS)
            
            let packets = custom.packets()
            for packet in packets {
                _ = hidDevice.write(command: packet)
            }
            
            _ = hidDevice.write(command: CK550Command.setEffect(effectId: .Off))
            _ = hidDevice.write(command: CK550Command.setCustomizationRGBControlUNKNOWN_AFTER_PACKETS)
            
            /*
             // Writes the color of keys in Off effect to flash
             _ = hidDevice.write(command: CK550Command.setProfileControl)
             _ = hidDevice.write(command: CK550Command.setEffectControl)
             _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
             _ = hidDevice.write(command: CK550Command.setFirmwareControl)
             */
            
            //_ = hidDevice.write(command: CK550Command.setEffectControl)
            //_ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 4))
            //_ = hidDevice.write(command: CK550Command.setEffect(effectId: .Off))
            
            _ = hidDevice.write(command: CK550Command.setFirmwareControl)
        }
    }
}

print("CK550 MacOS Utility")

let cli = CLI()
RunLoop.current.run()




//TODO: remove
//            _ = hidDevice.write(command: CK550Command.setLEDColor(key: 0x2e, red: 0x2F, green: 0x4F, blue: 0x4F))


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
