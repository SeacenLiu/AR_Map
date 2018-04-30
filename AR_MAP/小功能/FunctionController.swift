//
//  FunctionController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/30.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import AudioToolbox

class FunctionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func shakeAction(sender: UIButton) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

}
