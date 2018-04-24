//
//  SCNVector+EX.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/23.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

extension SCNVector3: Hashable {
    // 表示一个整数的比特数
    private var INT_BIT: Int {
        return (Int)(CHAR_BIT) * MemoryLayout<Int>.size
    }
    
    // 按位旋转
    private func bitwiseRotate(value: Int, bits: Int) -> Int {
        return (value << bits) | (value >> (INT_BIT - bits))
    }
    
    public var hashValue: Int {
        return bitwiseRotate(value: x.hashValue, bits: 10) ^ y.hashValue ^ z.hashValue
    }
    
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.z == rhs.z
    }
    
}
