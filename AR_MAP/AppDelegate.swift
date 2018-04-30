//
//  AppDelegate.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/14.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import UserNotifications

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
        
        /// 通知注册
        registerNotification()
        
        return true
    }
    
}

// MARK: - 本地推送代码(iOS11)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotification() {
        // 使用 UNUserNotificationCenter 来管理通知
        let center = UNUserNotificationCenter.current()
        // 监听回调事件
        center.delegate = self
        //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if let err = error {
                print(err)
                return
            }
            if granted {
                print("通知注册成功")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    /// App在前台时收到推送会调用
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("在前台时通知 : \(notification)")
    }
    /// App不在前台时收到推送用户点开会调用
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("不在前台时收到通知时 : \(response)")
    }
    
}

