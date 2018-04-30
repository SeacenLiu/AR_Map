//
//  SVProgressHUD+Ex.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/30.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation
import SVProgressHUD

private let kSVDefaultDuration: TimeInterval = 1

extension SVProgressHUD {
    class func showTip(status: String, duration: TimeInterval = kSVDefaultDuration) {
        SVProgressHUD.showInfo(withStatus: status)
        SVProgressHUD.dismiss(withDelay: duration)
    }
}
