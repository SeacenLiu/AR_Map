//
//  SCRecordView.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/3.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class SCRecordView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let view = UIApplication.shared.keyWindow?.rootViewController?.view
        view?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
}
