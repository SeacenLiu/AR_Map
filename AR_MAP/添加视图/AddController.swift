//
//  AddController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/1.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class AddController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addClick(_ sender: Any) {
        print("点击了添加按钮")
        // 1. 实例化视图
        let v = SCAddView.addView() //SCAddView()
        // 2. 显示视图
        v.show()
    }

}
