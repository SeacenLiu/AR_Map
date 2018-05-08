//
//  SCPositionManager.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/8.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

private let zCount = 10
private let yCount = 10

class SCPositionManager {
    // 给定位置的随机
    public func randomTransfrom() -> SCNMatrix4 {
        // 需要0到xCount-1的一个随机数
        let randomPoint = getXYFromArray() //getXYFromSet()
        let z = Float(randomPoint.z)
        let y = Float(randomPoint.y)
        // 计算出旋转矩阵
        let translation = SCNMatrix4Translate(SCNMatrix4Identity, 1, 0, 0)
        let zRotation = SCNMatrix4MakeRotation(xScale * z, 0, 0, 1)
        let yRotation = SCNMatrix4MakeRotation(yScale * y, 0, 1, 0)
        let transfrom = SCNMatrix4Mult(SCNMatrix4Mult(translation, zRotation), yRotation)
        // debug print
        print("randNumZ: \(randomPoint.z) ; randNumY: \(randomPoint.y)")
        return transfrom
    }
    
    // MARK: - private
    private let xScale =  Float.pi / Float(zCount)
    private let yScale =  Float.pi / Float(yCount)
    
    /// xy数组
    private lazy var xyArray: Array<Point> = {
        var array = Array<Point>()
        for i in 0..<zCount {
            for j in 0..<yCount {
                array.append(Point(y: i, z: j))
            }
        }
        array.shuffle()
        return array
    }()
    
    /// 在数组拿
    private func getXYFromArray() -> Point {
        if xyArray.isEmpty {
            print("空了啊")
            return Point(y: 0, z: 0)
        } else {
            return xyArray.removeFirst()
        }
    }
}

private struct Point {
    let y: Int
    let z: Int
}

// MARK: - Array extension
extension Array {
    /// 乱序数组
    public mutating func shuffle() {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        self = list
    }
}
