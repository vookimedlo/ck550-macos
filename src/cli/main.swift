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
        Terminal.important(" - Keyboard unplugged: \(hidDevice.product!) by \(hidDevice.manufacturer!)")
        
        dispatchQueue.async {
            self.hidDevice = nil
        }
    }
    
    func open(hidDevice: CK550HIDDevice) -> Bool {
        guard hidDevice.open() else {
            return false
        }
        self.hidDevice = hidDevice
        

        Terminal.important(" - Keyboard detected: \(hidDevice.product!) by \(hidDevice.manufacturer!)")
        
        if let version = getFirmwareVersion() {
            Terminal.general(" - FW version: \(version)")
        }
        
        // TODO: move
        setProfile(profileId: 3)

        //setOffEffectSingleKey(background: RGBColor(red: 0x00, green: 0xFF, blue: 0xFF), key: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00), speed: .Middle)
        //setOffEffectWave(color: RGBColor(red: 0xFF, green: 0xFF, blue: 0xFF), direction: .LeftToRight, speed: .Lower)
        //setOffEffectRipple(background: RGBColor(red: 0x00, green: 0x00, blue: 0x00), key: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00), speed: .Lowest)
        //setOffEffectBreathing(speed: .Highest)
        //setOffEffectColorCycle(speed: .Middle)
        //setOffEffectStatic(color: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00))
        //setOffEffectSnowing(background: RGBColor(red: 0x00, green: 0x00, blue: 0x00), key: RGBColor(red: 0xFF, green: 0xFF, blue: 0x00), speed: .Middle)

       setCustomColors(jsonPath: "/Users/duda/Development/_scm/CoolerMaster-ck550-macos/config/customization.json")

        return true
    }
    
    func printCommandResult(_ result: CK550HIDCommand.Result) {
        if result == .ok {
            Terminal.ok("[", result, "]", separator: "")
        }
        else {
            Terminal.error("[", result, "]", separator: "")
        }
    }
    
    func setProfile(profileId: uint8) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Switching a keyboard profle to", profileId, "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandChangeProfile(profileId: profileId)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectSnowing(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectSnowingSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a snowing effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandSnowing(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectOff() -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting an off effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandOff()
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectStatic(color: RGBColor) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a static effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandStatic(color: color)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectColorCycle(speed: CK550Command.OffEffectColorCycleSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a color cycle effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandColorCycle(speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectBreathing(speed: CK550Command.OffEffectBreathingSpeed, color: RGBColor? = nil) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a breathing effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandBreathing(speed: speed, color: color)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectRipple(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectRippleSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a ripple effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandRipple(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectWave(color: RGBColor, direction: CK550Command.OffEffectWaveDirection, speed: CK550Command.OffEffectWaveSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a wave effect", "...", separator: " ", terminator: " " )
            do {
                let command = try AssembleCommand.assembleCommandWave(color: color, direction: direction, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
    
    func setOffEffectSingleKey(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectSingleKeySpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("Setting a single key effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandSingleKey(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
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
                Terminal.error("Unexpected error")
            }
        }
        
        return nil
    }
    
    func setCustomColors(jsonPath: String) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("Setting a custom key color effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandCustomization(configPath: jsonPath)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch AssembleCommand.AssembleError.FileReadFailure(let path) {
                Terminal.error("Cannot read configuration file:", path)
            } catch AssembleCommand.AssembleError.InvalidFormatJSON {
                Terminal.error("Configuration file has a wrong format", jsonPath)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
}

Terminal.important("CK550 MacOS Utility")

let cli = CLI()

if cli.startHIDMonitoring() {
    Terminal.general(" - Monitoring HID...")
    RunLoop.current.run()
}
