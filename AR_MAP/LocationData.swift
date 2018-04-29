//
//  LocationData.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/29.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

class LocationData {
    
    var locations = [CLLocationCoordinate2D]()
    
    var datas = [[String: Double]]()
    
    func addData(location: CLLocationCoordinate2D) {
        locations.append(location)
        
        let dic = ["latitude": location.latitude, "longitude": location.longitude]
        datas.append(dic)
    }
    
    func saveToPlist() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let filePath = path! + "/locationData.plist"
        let testPath = path! + "/test.plist"
        print(filePath)
        NSArray(array: [1,2,3,4,5,6,7,2,8,9]).write(toFile: testPath, atomically: true)
        (datas as NSArray).write(toFile: filePath, atomically: true)
    }
}
