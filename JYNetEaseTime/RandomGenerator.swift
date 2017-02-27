//
//  RandomGenerator.swift
//  JYNetEaseTime
//
//  Created by atom on 2017/2/22.
//  Copyright © 2017年 atom. All rights reserved.
//

import Foundation

public extension Float {

    public static func random(min: Float = 0.0, max: Float = 1.0) -> Float{
    
        return (Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
}
