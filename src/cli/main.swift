//
//  main.swift
//  ck550-cli
//
//  Created by Michal Duda on 11/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class CLI: NSObject, HIDDeviceEnumeratedHandler {
    private let dispatchQueue = DispatchQueue(label: "cli", qos: .utility)
    private let hid = HIDRaw(CK550HIDDevice.self)
    private var hidDevice: CK550HIDDevice? = nil

    override init() {
        super.init()
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    func startHIDMonitoring() -> Bool {
        return hid.monitorEnumeration(vid: 0x2516, pid: 0x007f, usagePage: 0xFF00, usage: 0x00)
    }
    
    func deviceEnumerated(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceEnumerated else {return}
        
        let hidDevice = notification.userInfo?["device"] as! CK550HIDDevice
        //LogDebug("Enumerated device: %@", hidDevice.manufacturer!, hidDevice.product!)
        
        dispatchQueue.async {
            _ = self.open(hidDevice: hidDevice)
        }
    }
    
    func deviceRemoved(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceRemoved else {return}
        
        let hidDevice = notification.userInfo?["device"] as! HIDDevice
        print(" - Keyboard unplugged: \(hidDevice.product!) by \(hidDevice.manufacturer!)")
        
        dispatchQueue.async {
            self.hidDevice = nil
        }
    }
    
    func open(hidDevice: CK550HIDDevice) -> Bool {
        guard hidDevice.open() else {
            return false
        }
        self.hidDevice = hidDevice
        

        print(" - Keyboard detected: \(hidDevice.product!) by \(hidDevice.manufacturer!)")
        
        if let version = getFirmwareVersion() {
            print(" - FW version: \(version)")
        }
        
        // TODO: move
        setProfile(profileId: 3)
        //setEffect()
        //setOffEffectSingleKey(background: RGBColor(red: 0x00, green: 0xFF, blue: 0xFF), key: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00), speed: .Middle)
        //setOffEffectWave(color: RGBColor(red: 0xFF, green: 0xFF, blue: 0xFF), direction: .LeftToRight, speed: .Lower)
        //setOffEffectRipple(background: RGBColor(red: 0x00, green: 0x00, blue: 0x00), key: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00), speed: .Lowest)
        //setOffEffectBreathing(speed: .Highest)
        //setOffEffectColorCycle(speed: .Middle)
        //setOffEffectStatic(color: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00))
        //setOffEffectSnowing(background: RGBColor(red: 0x00, green: 0x00, blue: 0x00), key: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00), speed: .Middle)
       // saveCurrentProfile()
       // setFirmwareControl()
       setCustomColors(jsonPath: "/Users/duda/Development/_scm/CoolerMaster-ck550-macos/config/customization.json")
        

        
        return true
    }
    
    func setEffect() -> Void {
        if let hidDevice = self.hidDevice {
            let command = CK550HIDCommand()
            command.addOutgoingMessage(CK550Command.setEffectControl)
            command.addOutgoingMessage(CK550Command.setEffect(effectId: .Off))
            hidDevice.write(command: command)
            print(command.result)
        }
    }
    
    func setProfile(profileId: uint8) -> Void {
        if let hidDevice = self.hidDevice {
            let command = CK550HIDCommand()
            command.addOutgoingMessage(CK550Command.setProfileControl)
            command.addOutgoingMessage(CK550Command.setActiveProfile(profileId: profileId))
            hidDevice.write(command: command)
            print(command.result)
        }
    }
    
    func saveCurrentProfile() -> Void {
        if let hidDevice = self.hidDevice {
            let command = CK550HIDCommand()
            command.addOutgoingMessage(CK550Command.saveCurrentProfile)
            hidDevice.write(command: command)
            print(command.result)
        }
    }

    func setFirmwareControl() -> Void {
        if let hidDevice = self.hidDevice {
            let command = CK550HIDCommand()
            command.addOutgoingMessage(CK550Command.setFirmwareControl)
            hidDevice.write(command: command)
            print(command.result)
        }
    }
    
    func setOffEffectSnowing(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectSnowingSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandSnowing(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectOff() -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandOff()
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectStatic(color: RGBColor) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandStatic(color: color)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectColorCycle(speed: CK550Command.OffEffectColorCycleSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandColorCycle(speed: speed)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectBreathing(speed: CK550Command.OffEffectBreathingSpeed, color: RGBColor? = nil) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandBreathing(speed: speed, color: color)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectRipple(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectRippleSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandRipple(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectWave(color: RGBColor, direction: CK550Command.OffEffectWaveDirection, speed: CK550Command.OffEffectWaveSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandWave(color: color, direction: direction, speed: speed)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func setOffEffectSingleKey(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectSingleKeySpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandSingleKey(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                print(command.result)
            } catch {
                print("Unexpected error")
            }
        }
    }
    
    func getFirmwareVersion() -> String? {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandFirmwareVersion()
                hidDevice.write(command: command)
                if command.result == .ok {
                    // Throw away a FW control response
                    _ = command.responses.dequeue()
                    let fwArray = command.responses.dequeue()?[0x08...0x21]
                    let fwVersion = String(bytes: fwArray!, encoding: String.Encoding.utf16LittleEndian)?.filter({$0 != "\0"})
                    return fwVersion
                }
            } catch {
                print("Unexpected error")
            }
        }
        
        return nil
    }
    
    func setCustomColors(jsonPath: String) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandCustomization(configPath: jsonPath)
                hidDevice.write(command: command)
                print(command.result)
            } catch AssembleCommand.AssembleError.FileReadFailure(let path) {
                print("Cannot read configuration file:", path)
            } catch AssembleCommand.AssembleError.InvalidFormatJSON {
                print("Configuration file has a wrong format", jsonPath)
            } catch {
                print("Unexpected error")
            }
        }
    }
}



print("CK550 MacOS Utility")

let cli = CLI()
if cli.startHIDMonitoring() {
    print(" - Monitoring HID...")
    RunLoop.current.run()
}


//TODO: remove
//  _ = hidDevice.write(command: CK550Command.setLEDColor(key: 0x2e, red: 0x2F, green: 0x4F, blue: 0x4F))


//  _ = hidDevice.write(command: CK550Command.setProfileControl)
//  _ = hidDevice.write(command: CK550Command.getFirmwareVersion)

//  _ = hidDevice.write(command: CK550Command.setActiveProfile(profileId: 3))
//  _ = hidDevice.write(command: CK550Command.turnLEDsOff)
/// _ = hidDevice.write(command: CK550Command.setManualControl)
//  _ = hidDevice.write(command: CK550Command.setManualControl2)

//  _ = hidDevice.write(command: CK550Command.setLEDsColor(red: 0x2F, green: 0x4F, blue: 0x4F))
//  _ = hidDevice.write(command: CK550Command.setEffectControl)
//  _ = hidDevice.write(command: CK550Command.setEffect(effectId: 4))
//  _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
//  _ = hidDevice.write(command: CK550Command.setFirmwareControl)
//  _ = hidDevice.write(command: CK550Command.setLEDColor(key: 0x02, red: 0x00, green: 0x00, blue: 0xFF))
//  _ = hidDevice.write(command: CK550Command.setEffectControl)
//  _ = hidDevice.write(command: CK550Command.setEffect(effectId: 0))

//  _ = hidDevice.write(command: CK550Command.saveCurrentProfile)
//  _ = hidDevice.write(command: CK550Command.setFirmwareControl)
