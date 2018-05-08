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
    
    private lazy var xySet: Set<Point> = {
        var set = Set<Point>()
        for i in 0..<xCount {
            for j in 0..<yCount {
                set.insert(Point(x: i, y: j))
            }
        }
        return set
    }()
    
    private lazy var xyArray: Array<Point> = {
        var set = Array<Point>()
        for i in 0..<xCount {
            for j in 0..<yCount {
                set.append(Point(x: i, y: j))
            }
        }
        return set
    }()
    
    private func getXYFromArray() -> Point {
        if xyArray.isEmpty {
            print("空了啊")
            return Point(x: 0, y: 0)
        } else {
            return xyArray.removeFirst()
        }
    }
    
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
    var hashValue: Int {
        return "\(x),\(y)".hashValue
    }
    
    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    let x: Int
    let y: Int
    
//    init(x: Float, y: Float) {
//        self.init(x: x, y: y)
//    }
}
