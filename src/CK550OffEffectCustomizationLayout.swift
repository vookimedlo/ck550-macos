//
//  CK550OffEffectCustomizationLayout.swift
//  ck550-cli
//
//  Created by Michal Duda on 17/12/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

protocol CK550OffEffectCustomizationLayout {
    init()
    associatedtype Key

    func color(key: Key) -> RGBColor
    func setColor(key: Key, color: RGBColor)
    func packet(key: Key) -> Int
    func offset(key: Key) -> Int
    func keys(packet: Int) -> [Key]
    func key(packet: Int, offset: Int) -> Key?
}
