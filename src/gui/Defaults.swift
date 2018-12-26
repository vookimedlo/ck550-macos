//
//  Defaults.swift
//  ck550
//
//  Created by Michal Duda on 24/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation
import Cocoa

struct Defaults {
    enum Key: String{
        case staticKeys
        case wave
        case crossMode
        case singleKey
        case customization
        case star
        case colorCycle
        case breathing
        case ripple
        case snowing
        case reactivePunch
        case heartbeat
        case fireball
        case circleSpectrum
        case reactiveTornado
        case waterRipple
        case off
    }
    
    
    
    /*
 
     data["effects"] = [ "staticKeys": [ "color": <color>, "speed": <speed> ],
                         "
 
     */
    
  //  static let (nameKey, addressKey) = ("name", "address")
  //  static let userSessionKey = "com.save.usersession"
    
  //  static var saveNameAndAddress = { (name: String, address: String) in
//        UserDefaults.standard.set([nameKey: name, addressKey: address], forKey: userSessionKey)
    //}
    
//    static var getNameAndAddress = { _ -> Model in
//        return Model((UserDefaults.standard.value(forKey: userSessionKey) as? [String: String]) ?? [:])
//    }(())
    
//    static func clearUserData(){
  //      UserDefaults.standard.removeObject(forKey: userSessionKey)
    //}
}
