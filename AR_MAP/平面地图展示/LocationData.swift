//
//  LocationData.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/29.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

class LocationData {
    
    /// 保存[CLLocationCoordinate2D]
    class func saveLocationData(arr: [CLLocationCoordinate2D]) {
        let traceData = LocationData()
        arr.forEach {
            traceData.addData(location: $0)
        }
        traceData.saveToPlist()
    }
    
    var locations = [CLLocationCoordinate2D]()
    
    var datas = [[String: Double]]()
    
    func addData(location: CLLocationCoordinate2D) {
        locations.append(location)
        let dic = ["latitude": location.latitude, "longitude": location.longitude]
        datas.append(dic)
    }
    
    func saveToPlist() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let timePath = Date().description
        let filePath = path! + "/" + timePath + "locationData.plist"
        print(filePath)
        (datas as NSArray).write(toFile: filePath, atomically: true)
    }
}
