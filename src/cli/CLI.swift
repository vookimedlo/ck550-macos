//
//  CLI.swift
//  ck550-cli
//
//  Created by Michal Duda on 12/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class CLI: NSObject, HIDDeviceEnumeratedHandler {
    private let dispatchQueue = DispatchQueue(label: "cli", qos: .utility)
    private let hid = HIDRaw(CK550HIDDevice.self)
    private var hidDevice: CK550HIDDevice? = nil
    private var onOpenFunction: () -> Void = {
    }

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
        guard notification.name == Notification.Name.CustomHIDDeviceEnumerated else {
            return
        }

        let hidDevice = notification.userInfo?["device"] as! CK550HIDDevice
        //LogDebug("Enumerated device: %@", hidDevice.manufacturer!, hidDevice.product!)

        dispatchQueue.async {
            _ = self.open(hidDevice: hidDevice)
        }
    }

    func deviceRemoved(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceRemoved else {
            return
        }

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
            Terminal.general("   - FW version: \(version)")
        }

        dispatchQueue.async {
            self.onOpenFunction()
        }

        return true
    }

    func onOpen(_ function: @escaping () -> Void) -> Void {
        onOpenFunction = function
    }

    func printCommandResult(_ result: CK550HIDCommand.Result) {
        if result == .ok {
            Terminal.ok("[", result, "]", separator: "")
        } else {
            Terminal.error("[", result, "]", separator: "")
        }
    }

    func setProfile(profileId: uint8) -> Bool {
        if let hidDevice = self.hidDevice {
            Terminal.general("   - Switching a keyboard profile to", profileId, "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandChangeProfile(profileId: profileId)
                hidDevice.write(command: command)
                printCommandResult(command.result)
                return CK550HIDCommand.Result.ok == command.result
            } catch {
                Terminal.error("Unexpected error")
            }
        }
        return false
    }

    func setOffEffectSnowing(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectSnowingSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("   - Setting a snowing effect", "...", separator: " ", terminator: " ")
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
            Terminal.general("   - Setting an off effect", "...", separator: " ", terminator: " ")
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
            Terminal.general("   - Setting a static effect", "...", separator: " ", terminator: " ")
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
            Terminal.general("   - Setting a color cycle effect", "...", separator: " ", terminator: " ")
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
            Terminal.general("   - Setting a breathing effect", "...", separator: " ", terminator: " ")
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
            Terminal.general("   - Setting a ripple effect", "...", separator: " ", terminator: " ")
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
            Terminal.general("   - Setting a wave effect", "...", separator: " ", terminator: " ")
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
                Terminal.general("   - Setting a single key effect", "...", separator: " ", terminator: " ")
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
                    let fwVersion = String(bytes: fwArray!, encoding: String.Encoding.utf16LittleEndian)?.filter({ $0 != "\0" })
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
            Terminal.general("   - Setting a custom key color effect", "...", separator: " ", terminator: " ")
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

    func setOffEffectStars(key: RGBColor, background: RGBColor, speed: CK550Command.OffEffectStarsSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a stars effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandStars(key: key, background: background, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectReactiveTornado(direction: CK550Command.OffEffectReactiveTornadoDirection, speed: CK550Command.OffEffectReactiveTornadoSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a reactive tornado effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandReactiveTornado(direction: direction, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectCircleSpectrum(speed: CK550Command.OffEffectCircleSpectrumSpeed, direction: CK550Command.OffEffectCircleSpectrumDirection) -> Void {
        if let hidDevice = self.hidDevice {
            Terminal.general("   - Setting a circle spectrum effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandCircleSpectrum(direction: direction, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectFireball(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectFireballSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a fireball effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandFireball(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectHeartbeat(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectHeartbeatSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a heartbeat effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandHeartbeat(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectReactivePunch(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectReactivePunchSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a reactive punch effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandReactivePunch(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectWaterRipple(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectWaterRippleSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a water ripple effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandWaterRipple(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectCrosshair(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectCrosshairSpeed) -> Void {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - Setting a crosshair effect", "...", separator: " ", terminator: " ")
                let command = try AssembleCommand.assembleCommandCrosshair(background: background, key: key, speed: speed)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
}
