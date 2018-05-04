//
//  SCBaseNode.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/4.
//  Copyright © 2018年 成. All rights reserved.
//

import SceneKit

class SCBaseNode: SCNNode {

    /// 用于显示的结点
    var showNode: SCNNode?
    
    init(showNode: SCNNode) {
        super.init()
        self.showNode = showNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBaseAction(action: SCNAction, finish block: (() -> Swift.Void)? = nil) {
        runAction(action, completionHandler: block)
    }
    
    func addShowAction(action: SCNAction, finish block: (() -> Swift.Void)? = nil) {
        showNode?.runAction(action, completionHandler: block)
    }
    
}
