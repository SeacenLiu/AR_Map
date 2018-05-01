//
//  SCAddView.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/1.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class SCAddView: UIView {

    class func addView() -> SCAddView {
        let nib = UINib(nibName: "SCAddView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! SCAddView
        v.frame = UIScreen.main.bounds
        return v
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: UIScreen.main.bounds)
//        backgroundColor = .red
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func show() {
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else { return }
        vc.view.addSubview(self)
        
    }
    
    func dissmiss() {
        
    }
}
