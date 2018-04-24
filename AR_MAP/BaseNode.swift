//
//  BaseNode.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import SceneKit
import UIKit
import ARKit
import CoreLocation

class BaseNode: SCNNode {
    
    let title: String
    var anchor: ARAnchor?
    var location: CLLocation!
    
    var image: UIImage?
    
    init(title: String, location: CLLocation) {
        self.title = title
        super.init()
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
//        addNode(with: 0.1, and: .red, and: title)
        add()
    }
    
    func add() {
        let rect = CGRect(x: 0, y: 0, width: 250, height: 125)
        let size = CGSize(width: 250, height: 125)
        UIGraphicsBeginImageContext(size)
        if let ctx = UIGraphicsGetCurrentContext() {
            // 先来个背景颜色
            ctx.setFillColor(UIColor.lightGray.cgColor)
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
            let attrString = NSAttributedString(string: self.title, attributes: dic)
            
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
            // 绘制
            CTFrameDraw(frame,ctx)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let geometry = SCNPlane(width: 0.25, height: 0.125)
        geometry.firstMaterial?.diffuse.contents = image
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
//        let _textNode = SCNNode(geometry: newText)
//        let annotationNode = SCNNode()
//        annotationNode.addChildNode(_textNode)
//        annotationNode.position = sphereNode.position
        addChildNode(sphereNode)
//        addChildNode(annotationNode)
        
        geometry = newText
    }
}

