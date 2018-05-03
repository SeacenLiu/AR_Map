//
//  SCNVector3+Ex.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/3.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    func distance(to anotherVector: SCNVector3) -> Double {
        return Double(sqrt(pow(anotherVector.x - x, 2) + pow(anotherVector.z - z, 2) + pow(anotherVector.y - y, 2)))
    }
}
