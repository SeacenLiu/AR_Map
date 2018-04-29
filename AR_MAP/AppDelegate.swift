//
//  AppDelegate.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/14.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AMapServices.shared().apiKey = "a092e82e7d3058c4f26c7e9579c39b23"
        
//        SCLocationManager.shared.arroundSearch { (arr) in
//            arr.forEach {
//                print($0.name)
//                print($0.location)
//            }
//        }
        
        return true
    }
    
}

