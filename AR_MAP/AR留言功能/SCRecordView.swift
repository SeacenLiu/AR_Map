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
    
}
