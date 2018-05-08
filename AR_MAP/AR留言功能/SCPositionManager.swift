//
//  SCPositionManager.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/8.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

private let xCount = 10
private let yCount = 10

class SCPositionManager {
    // 给定位置的随机
    public func randomTransfrom() -> SCNMatrix4 {
        // 需要0到xCount-1的一个随机数
        let randomPoint = getXYFromArray() //getXYFromSet()
        let z = Float(randomPoint.x)
        let y = Float(randomPoint.y)
        // 计算出旋转矩阵
        let translation = SCNMatrix4Translate(SCNMatrix4Identity, 1, 0, 0)
        let zRotation = SCNMatrix4MakeRotation(xScale * z, 0, 0, 1)
        let yRotation = SCNMatrix4MakeRotation(yScale * y, 0, 1, 0)
        let transfrom = SCNMatrix4Mult(SCNMatrix4Mult(translation, zRotation), yRotation)
        // debug print
        print("randNumX: \(randomPoint.x) ; randNumY: \(randomPoint.y)")
        return transfrom
    }
    
    // MARK: - private
    private let xScale =  Float.pi / Float(xCount)
    private let yScale =  Float.pi / Float(yCount)
    
    /// xy集合
    private lazy var xySet: Set<Point> = {
        var set = Set<Point>()
        for i in 0..<xCount {
            for j in 0..<yCount {
                set.insert(Point(x: i, y: j))
            }
        }
        return set
    }()
    
    /// xy数组
    private lazy var xyArray: Array<Point> = {
        var array = Array<Point>()
        for i in 0..<xCount {
            for j in 0..<yCount {
                array.append(Point(x: i, y: j))
            }
        }
        array.shuffle()
        return array
    }()
    
    /// 在数组拿
    private func getXYFromArray() -> Point {
        if xyArray.isEmpty {
            print("空了啊")
            return Point(x: 0, y: 0)
        } else {
            return xyArray.removeFirst()
        }
    }
    
    /// 在集合拿
    private func getXYFromSet() -> Point {
        if xySet.isEmpty {
            print("空了啊")
            return Point(x: 0, y: 0)
        } else {
            return xySet.removeFirst()
        }
    }
}

private struct Point: Hashable {
    /// 为了使用集合遵循的Hashable
    var hashValue: Int {
        return "\(x),\(y)".hashValue
    }
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    let x: Int
    let y: Int
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
