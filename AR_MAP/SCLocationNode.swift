//
//  SCLocationNode.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import SceneKit
import UIKit
import ARKit
import CoreLocation

class SCLocationNode: SCNNode {
    
    var title: String?
    var anchor: ARAnchor?
    var location: CLLocation!
    
    var image: UIImage?
    
    init(title: String, location: CLLocation) {
        self.title = title
        super.init()
        // 增加广告牌约束
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        add()
//        addNode(with: 0.1, and: .red, and: title)
    }
    
    func add() {
        let rect = CGRect(x: 0, y: 0, width: 250, height: 125)
        let size = CGSize(width: 250, height: 125)
        UIGraphicsBeginImageContext(size)
        if let ctx = UIGraphicsGetCurrentContext() {
            // 先来个背景颜色
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(rect)
            
            // 翻转坐标轴
            ctx.textMatrix = CGAffineTransform.identity
            ctx.translateBy(x: 0, y: rect.size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            // 创建路径
            let path = CGMutablePath()
            path.addRect(rect)
            
            // 居中
            var alignment = CTTextAlignment.center
            let alignmentStyle = CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout.size(ofValue: alignment), value: &alignment)
            let settings = [alignmentStyle]
            let paragraphStyle = CTParagraphStyleCreate(settings, MemoryLayout.size(ofValue: alignment))
            
            // 要绘制的字符串
            let dic = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 30),
                       NSAttributedStringKey.foregroundColor:UIColor.red,
                       NSAttributedStringKey.paragraphStyle:paragraphStyle] as [NSAttributedStringKey : Any]
            let attrString = NSAttributedString(string: self.title ?? "无名地点", attributes: dic)
            
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
            // 绘制
            CTFrameDraw(frame,ctx)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 加上背景结点
        let contentGeometry = SCNPlane(width: 0.25, height: 0.125)
        contentGeometry.firstMaterial?.diffuse.contents = UIColor.white
        contentGeometry.firstMaterial?.transparency = 0.5
        self.geometry = contentGeometry
        
        let bgGeometr = SCNPlane(width: 0.25, height: 0.125)
        bgGeometr.firstMaterial?.diffuse.contents = image
        let node = SCNNode(geometry: bgGeometr)
        node.position = SCNVector3(0,0,0.001)
        addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 点加字的显示
extension SCLocationNode {
    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
    }
    
    func addSphere(with radius: CGFloat, and color: UIColor) {
        let sphereNode = createSphereNode(with: radius, color: color)
        addChildNode(sphereNode)
    }
    
    func addNode(with radius: CGFloat, and color: UIColor, and text: String) {
        let sphereNode = createSphereNode(with: radius, color: color)
        let newText = SCNText(string: title, extrusionDepth: 0.05)
        newText.font = UIFont (name: "AvenirNext-Medium", size: 1)
        newText.firstMaterial?.diffuse.contents = UIColor.red
        addChildNode(sphereNode)
        geometry = newText
    }
}

