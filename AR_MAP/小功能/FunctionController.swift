//
//  FunctionController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/30.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import AudioToolbox
import UserNotifications

class FunctionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// 本地推送
    @IBAction func localNotification(_ sender: Any) {
        testNotification()
    }
    
    /// 震动一下
    @IBAction func shakeAction(sender: UIButton) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

}

// MARK: - 本地推送代码(iOS11)
extension FunctionController {
    func testNotification() {
        // 使用 UNUserNotificationCenter 来管理通知
        let center = UNUserNotificationCenter.current()
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        let content = UNMutableNotificationContent()
        // 标题
        content.title = "标题"
        // 子标题
        content.subtitle = "子标题"
        // 内容
        content.body = "内容"
        // 标记个数
        content.badge = 1
        // 推送提示音
        content.sound = UNNotificationSound.default()
        
        // 指定音频文件
//        content.sound = UNNotificationSound(named: "prompt.mp3")
        
        // 附加信息
        content.userInfo = ["key1": "value1", "key2": "value2"]
        // 添加附件
        if let imageUrl = Bundle.main.url(forResource: "nico", withExtension: "jpg"),
            let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageUrl, options: nil) {
            content.attachments = [attachment]
        } else {
            print("添加附件失败")
        }
        
        // 通过时间差，多少秒后推送本地推送
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let request = UNNotificationRequest(identifier: "Seacen", content: content, trigger: trigger)
        
        // 通过时间来推送
//        let dateComponents = NSDateComponents()
//        dateComponents.year = 2018
//        dateComponents.month = 4
//        dateComponents.day = 30
//        dateComponents.hour = 16
//        dateComponents.minute = 48
//        dateComponents.second = 0
//        let triggerDate = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // 在 进入某个区域后 推送本地推送(注意：此处用CLCircularRegion，不要用CLRegion)
//        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 21, longitude: 110), radius: 1000, identifier: "SeacenRegion")
//        let triggerRegion = UNLocationNotificationTrigger(region: region, repeats: false)
        
        // 添加推送成功后的处理
        center.add(request) { (error) in
            if let err = error {
                print(err)
                return
            }
            print("推送添加成功")
        }
    }
}
