//
//  KeyboardGUIHandler.swift
//  ck550
//
//  Created by Michal Duda on 29/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

// swiftlint:disable type_body_length file_length
class KeyboardGUIHandler: NSObject, HIDDeviceEnumeratedHandler, MenuToggledHandler, EffectToggledHandler, ConfigurationChangedHandler {
    private let dispatchQueue = DispatchQueue(label: "keyboardGUI", qos: .utility)
    private let hidQueue = DispatchQueue(label: "hidGUI", qos: .utility)
    private let hid = HIDRaw(CK550HIDDevice.self)
    private var hidDevice: CK550HIDDevice?
    private var onOpenFunction: () -> Void = {}
    private var onOpenEnabled: Bool = true
    private var onSleepWakeEnabled: Bool = true
    private var configuration = AppPreferences()
    private var activeEffect: Effect?

    func start() {
        configuration.read()
        (self as HIDDeviceEnumeratedHandler).startObserving()
        (self as MenuToggledHandler).startObserving()
        (self as EffectToggledHandler).startObserving()
        (self as ConfigurationChangedHandler).startObserving()

        // Sleep / wake notifications
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(receiveSleepNotification(notification:)),
                                                          name: NSWorkspace.willSleepNotification,
                                                          object: nil)

        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(receiveWakeNotification(notification:)),
                                                          name: NSWorkspace.didWakeNotification,
                                                          object: nil)

        hidQueue.async {
            _ = self.startHIDMonitoring()
            CFRunLoopRun()
        }
    }

    func stop() {
        // tear down our effect changes and restore the previously selected profile configuration
        _ = resetProfile()

        (self as ConfigurationChangedHandler).stopObserving()
        (self as MenuToggledHandler).stopObserving()
        (self as HIDDeviceEnumeratedHandler).stopObserving()
        (self as EffectToggledHandler).stopObserving()

        NSWorkspace.shared.notificationCenter.removeObserver(self,
                                                             name: NSWorkspace.willSleepNotification,
                                                             object: nil)

        NSWorkspace.shared.notificationCenter.removeObserver(self,
                                                             name: NSWorkspace.didWakeNotification,
                                                             object: nil)

        hidQueue.async {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
    }

    @objc func receiveSleepNotification(notification: Notification) {
        logDebug("System sleep notification")
        if onSleepWakeEnabled {
            setOffEffectOff()
        }
    }

    @objc func receiveWakeNotification(notification: Notification) {
        logDebug("System wake notification")
        if onSleepWakeEnabled {
            if let effect = activeEffect {
                scheduleEffect(effect)
            } else {
                _ = resetProfile()
            }
        }
    }

    // swiftlint:disable large_tuple
    func effectPreferences(_ effect: Effect) -> (color: RGBColor, colorOrNil: RGBColor?, backgroundColor: RGBColor, speedIndex: Int, directionIndex: Int ) {
    // swiftlint:enable large_tuple
        switch effect {
        case .off, .customization:
            return (RGBColor(), nil, RGBColor(), -1, -1)
        default:
            let json = configuration[.effect][effect.rawValue]
            let isColorRandom = json[AppPreferences.EffectKeys.isColorRandom.rawValue].boolValue
            let speedIndex = json[AppPreferences.EffectKeys.speed.rawValue].int ?? 2
            let color = RGBColor(json: json[AppPreferences.EffectKeys.color.rawValue])
            let backgroundColor = RGBColor(json: json[AppPreferences.EffectKeys.backgroundColor.rawValue])
            let directionIndex = json[AppPreferences.EffectKeys.direction.rawValue].int ?? -1
            return (color,
                    isColorRandom ? nil : color,
                    backgroundColor,
                    speedIndex,
                    directionIndex)
        }
    }

    private func scheduleEffect(_ effect: Effect) {
        typealias Cmd = CK550Command.OffEffectOverride
        let preferences = effectPreferences(effect)
        switch effect {
        case .staticKeys:
            setOffEffectStatic(color: preferences.color)
            onOpen {self.setOffEffectStatic(color: preferences.color)}
        case .wave:
            let execute = {
                self.setOffEffectWave(color: preferences.color,
                                      direction: Cmd.Wave.Direction(rawValue: preferences.directionIndex)!,
                                      speed: Cmd.Wave.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .crossMode:
            let execute = {
                self.setOffEffectCrosshair(background: preferences.backgroundColor,
                                           key: preferences.color,
                                           speed: Cmd.Crosshair.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .singleKey:
            let execute = {
                self.setOffEffectSingleKey(background: preferences.backgroundColor,
                                           key: preferences.color,
                                           speed: Cmd.SingleKey.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .customization:
            print("")
        case .star:
            let execute = {
                self.setOffEffectStars(key: preferences.color,
                                       background: preferences.backgroundColor,
                                       speed: Cmd.Stars.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .colorCycle:
            let execute = {
                self.setOffEffectColorCycle(speed: Cmd.ColorCycle.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .breathing:
            let execute = {
                self.setOffEffectBreathing(speed: Cmd.Breathing.Speed(rawValue: preferences.speedIndex)!,
                                           color: preferences.colorOrNil)
            }
            execute()
            onOpen {execute()}
        case .ripple:
            let execute = {
                self.setOffEffectRipple(background: preferences.backgroundColor,
                                        key: preferences.color,
                                        speed: Cmd.Ripple.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .snowing:
            let execute = {
                self.setOffEffectSnowing(background: preferences.backgroundColor,
                                         key: preferences.color,
                                         speed: Cmd.Snowing.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .reactivePunch:
            let execute = {
                self.setOffEffectReactivePunch(background: preferences.backgroundColor,
                                               key: preferences.colorOrNil,
                                               speed: Cmd.ReactivePunch.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .heartbeat:
            let execute = {
                self.setOffEffectHeartbeat(background: preferences.backgroundColor,
                                           key: preferences.colorOrNil,
                                           speed: Cmd.Heartbeat.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .fireball:
            let execute = {
                self.setOffEffectFireball(background: preferences.backgroundColor,
                                          key: preferences.colorOrNil,
                                          speed: Cmd.Fireball.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .circleSpectrum:
            let execute = {
                self.setOffEffectCircleSpectrum(speed: Cmd.CircleSpectrum.Speed(rawValue: preferences.speedIndex)!,
                                                direction: Cmd.CircleSpectrum.Direction(rawValue: preferences.directionIndex)!)
            }
            execute()
            onOpen {execute()}
        case .reactiveTornado:
            let execute = {
                self.setOffEffectReactiveTornado(direction: Cmd.ReactiveTornado.Direction(rawValue: preferences.directionIndex)!,
                                                 speed: Cmd.ReactiveTornado.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .waterRipple:
            let execute = {
                self.setOffEffectWaterRipple(background: preferences.backgroundColor,
                                             key: preferences.colorOrNil,
                                             speed: Cmd.WaterRipple.Speed(rawValue: preferences.speedIndex)!)
            }
            execute()
            onOpen {execute()}
        case .off:
            setOffEffectOff()
            onOpen {self.setOffEffectOff()}
        }
    }

    func configurationChanged(notification: Notification) {
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomConfigurationChanged)
            else {return}
        guard let configuration = userInfo[.configuration] as? AppPreferences else {return}
        self.configuration = configuration
        if let effect = activeEffect {
            scheduleEffect(effect)
        }
    }

    func effectToggled(notification: Notification) {
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomEffectToggled)
            else {return}
        guard let effect = userInfo[.effect] as? Effect else {return}
        guard let isEnabled = userInfo[.isEnabled] as? Bool else {return}
        if !isEnabled {
            activeEffect = nil
            onOpen {}
            _ = resetProfile()
        } else {
            activeEffect = effect
            scheduleEffect(effect)
        }
    }

    func menuToggled(notification: Notification) {
        guard let userInfo = UserInfo(notification: notification,
                                      expected: Notification.Name.CustomMenuToggled)
            else {return}

        if let isEnabled = userInfo[.isMonitoringEnabled] as? Bool {
            if isEnabled {
                onOpenFunction()
            }
            onOpenEnabled = isEnabled
        } else
        if let isEnabled = userInfo[.isSleepWakeEnabled] as? Bool {
            onSleepWakeEnabled = isEnabled
        }
    }

    func startHIDMonitoring() -> Bool {
        return hid.monitorEnumeration(vid: 0x2516, pid: 0x007f, usagePage: 0xFF00, usage: 0x00)
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

        var userInfoBuilder = UserInfo()
        userInfoBuilder[.isPlugged] = false
        let notification = Notification(name: .CustomKeyboardInfo,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)

        dispatchQueue.async {
            self.hidDevice = nil
        }
    }

    func open(hidDevice: CK550HIDDevice) -> Bool {
        guard hidDevice.open() else {
            return false
        }
        self.hidDevice = hidDevice

        var userInfoBuilder = UserInfo()
        userInfoBuilder[.isPlugged] = true
        userInfoBuilder[.product] = hidDevice.product!
        userInfoBuilder[.manufacturer] = hidDevice.manufacturer!

        Terminal.important(" - Keyboard detected: \(hidDevice.product!) by \(hidDevice.manufacturer!)")

        if let version = getFirmwareVersion() {
            userInfoBuilder[.fwVersion] = version
            Terminal.general("   - FW version: \(version)")
        }

        let notification = Notification(name: .CustomKeyboardInfo,
                                        object: self,
                                        userInfo: userInfoBuilder.userInfo)
        NotificationCenter.default.post(notification)

        dispatchQueue.async {
            if self.onOpenEnabled {
                self.onOpenFunction()
            }
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

    func resetProfile() -> Bool {
        if let hidDevice = self.hidDevice {
            Terminal.general("   - Resetting active profile", "...", separator: " ", terminator: " ")
            let command = CK550HIDCommand()
            command.addOutgoingMessage(CK550Command.setProfileControl)
            command.addOutgoingMessage(CK550Command.setFirmwareControl)
            hidDevice.write(command: command)
            printCommandResult(command.result)
            return CK550HIDCommand.Result.succeeded == command.result
        }
        return false
    }

    func setProfile(profileId: uint8) -> Bool {
        if let hidDevice = self.hidDevice {
            Terminal.general("   - Switching a keyboard profile to", profileId, "...", separator: " ", terminator: " ")
            do {
                let command = try AssembleCommand.assembleCommandChangeProfile(profileId: profileId)
                command.addOutgoingMessage(CK550Command.setFirmwareControl)
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
// swiftlint:enable type_body_length file_length
