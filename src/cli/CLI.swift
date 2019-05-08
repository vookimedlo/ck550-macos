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

class CLI: NSObject, HIDDeviceEnumeratedHandler {
    private let dispatchQueue = DispatchQueue(label: "cli", qos: .utility)
    private let hid = HIDEnumerator(CK550HIDDevice.self)
    private var hidDevice: CK550HIDDevice?
    private var onOpenFunction: () -> Void = {}

    override init() {
        super.init()
        startObserving()
    }

    deinit {
        stopObserving()
    }

    func startHIDMonitoring() -> Bool {
        return hid.monitorEnumeration(vid: keyboardVID,
                                      pids: KeyboardPIDs.allCases.map { $0.rawValue },
                                      usagePage: 0xFF00,
                                      usage: 0x00)
    }

    func deviceEnumerated(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceEnumerated else {
            return
        }

// swiftlint:disable force_cast
        let hidDevice = notification.userInfo?["device"] as! CK550HIDDevice
// swiftlint:enable force_cast

        logDebug("Enumerated device: %@", hidDevice.manufacturer!, hidDevice.product!)

        dispatchQueue.async {
            _ = self.open(hidDevice: hidDevice)
        }
    }

    func deviceRemoved(notification: Notification) {
        guard notification.name == Notification.Name.CustomHIDDeviceRemoved else {
            return
        }

// swiftlint:disable force_cast
        let hidDevice = notification.userInfo?["device"] as! HIDDevice
// swiftlint:enable force_cast
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

    func onOpen(_ function: @escaping () -> Void) {
        onOpenFunction = function
    }

    func printCommandResult(_ result: CK550HIDCommand.Result) {
        if result == .succeeded {
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
                return CK550HIDCommand.Result.succeeded == command.result
            } catch {
                Terminal.error("Unexpected error")
            }
        }
        return false
    }

    func getFirmwareVersion() -> String? {
        if let hidDevice = self.hidDevice {
            do {
                let command = try AssembleCommand.assembleCommandFirmwareVersion()
                hidDevice.write(command: command)
                if command.result == .succeeded {
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

    func setCustomColors(jsonPath: String) {
        if let hidDevice = self.hidDevice {
            Terminal.general("   - Setting a custom key color effect", "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandCustomization(configPath: jsonPath)
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch AssembleCommand.AssembleError.fileReadFailure(let path) {
                Terminal.error("Cannot read configuration file:", path)
            } catch AssembleCommand.AssembleError.invalidFormatJSON {
                Terminal.error("Configuration file has a wrong format", jsonPath)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }

    func setOffEffectSnowing(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectOverride.Snowing.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandSnowing(background: background, key: key, speed: speed)},
                                 description: "Setting a snowing effect")
    }

    func setOffEffectOff() {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandOff()},
                                 description: "Setting an off effect")
    }

    func setOffEffectStatic(color: RGBColor) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandStatic(color: color)},
                                 description: "Setting a static effect")
    }

    func setOffEffectColorCycle(speed: CK550Command.OffEffectOverride.ColorCycle.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandColorCycle(speed: speed)},
                                 description: "Setting a color cycle effect")
    }

    func setOffEffectBreathing(speed: CK550Command.OffEffectOverride.Breathing.Speed, color: RGBColor? = nil) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandBreathing(speed: speed, color: color)},
                                 description: "Setting a breathing effect")
    }

    func setOffEffectRipple(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectOverride.Ripple.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandRipple(background: background, key: key, speed: speed)},
                                 description: "Setting a ripple effect")
    }

    func setOffEffectWave(color: RGBColor, direction: CK550Command.OffEffectOverride.Wave.Direction, speed: CK550Command.OffEffectOverride.Wave.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandWave(color: color, direction: direction, speed: speed)},
                                 description: "Setting a wave effect")
    }

    func setOffEffectSingleKey(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectOverride.SingleKey.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandSingleKey(background: background, key: key, speed: speed)},
                                 description: "Setting a single key effect")
    }

    func setOffEffectStars(key: RGBColor, background: RGBColor, speed: CK550Command.OffEffectOverride.Stars.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandStars(key: key, background: background, speed: speed)},
                                 description: "Setting a stars effect")
    }

    func setOffEffectReactiveTornado(direction: CK550Command.OffEffectOverride.ReactiveTornado.Direction, speed: CK550Command.OffEffectOverride.ReactiveTornado.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandReactiveTornado(direction: direction, speed: speed)},
                                 description: "Setting a reactive tornado effect")
    }

    func setOffEffectCircleSpectrum(speed: CK550Command.OffEffectOverride.CircleSpectrum.Speed, direction: CK550Command.OffEffectOverride.CircleSpectrum.Direction) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandCircleSpectrum(direction: direction, speed: speed)},
                                 description: "Setting a circle spectrum effect")
    }

    func setOffEffectFireball(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectOverride.Fireball.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandFireball(background: background, key: key, speed: speed)},
                                 description: "Setting a fireball effect")
    }

    func setOffEffectHeartbeat(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectOverride.Heartbeat.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandHeartbeat(background: background, key: key, speed: speed)},
                                 description: "Setting a heartbeat effect")
    }

    func setOffEffectReactivePunch(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectOverride.ReactivePunch.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandReactivePunch(background: background, key: key, speed: speed)},
                                 description: "Setting a reactive punch effect")
    }

    func setOffEffectWaterRipple(background: RGBColor, key: RGBColor?, speed: CK550Command.OffEffectOverride.WaterRipple.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandWaterRipple(background: background, key: key, speed: speed)},
                                 description: "Setting a water ripple effect")
    }

    func setOffEffectCrosshair(background: RGBColor, key: RGBColor, speed: CK550Command.OffEffectOverride.Crosshair.Speed) {
        executeOffOverrideEffect({ return try AssembleCommand.assembleCommandCrosshair(background: background, key: key, speed: speed)},
                                 description: "Setting a crosshair effect")
    }

    func executeOffOverrideEffect(_ commandCreation: () throws -> CK550HIDCommand, description: String) {
        if let hidDevice = self.hidDevice {
            do {
                Terminal.general("   - " + description, "...", separator: " ", terminator: " ")
                let command = try commandCreation()
                hidDevice.write(command: command)
                printCommandResult(command.result)
            } catch {
                Terminal.error("Unexpected error")
            }
        }
    }
}
