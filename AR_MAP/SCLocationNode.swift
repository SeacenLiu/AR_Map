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
//import CoreLocation

let locationNodeH: CGFloat = 0.14
let locationNodeW: CGFloat = 0.25

class SCLocationNode: SCNNode {
    
    /// 标题
    var title: String?
    /// 位置
    var location: AMapGeoPoint!
    /// 距离(单位: m) 返回的好像有问题
    var distance: Int?
    /// 贴图
    var image: UIImage?
    /// 锚点
    var anchor: ARAnchor?
    
    init(title: String, location: AMapGeoPoint, distance: Int) {
        self.title = title
        super.init()
        // 增加广告牌约束
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        setupNode()
//        addNode(with: 0.1, and: .red, and: title)
    }
    
    func setupNode() {
        let rect = CGRect(x: 0, y: 0, width: locationNodeW*1000, height: locationNodeH*1000)
        let size = CGSize(width: locationNodeW*1000, height: locationNodeH*1000)
        UIGraphicsBeginImageContext(size)
        if let ctx = UIGraphicsGetCurrentContext() {
            // 位置摆放
            let locationRect = CGRect(x: 0, y: size.height*0.4, width: size.width, height: size.height*0.5)
            let distanceRect = CGRect(x: 0, y: -size.height*0.2, width: size.width, height: size.height*0.5)
            
            // 先来个背景颜色
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(rect)
//            ctx.setFillColor(UIColor.red.cgColor)
//            ctx.fill(locationRect)
//            ctx.setFillColor(UIColor.blue.cgColor)
//            ctx.fill(distanceRect)
            
            // 翻转坐标轴
            ctx.textMatrix = CGAffineTransform.identity
            ctx.translateBy(x: 0, y: rect.size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            
            // 创建路径
            let locationPath = CGMutablePath()
            locationPath.addRect(locationRect)
            
            let distancePath = CGMutablePath()
            distancePath.addRect(distanceRect)
            
            // 居中
            var alignment = CTTextAlignment.center
            let alignmentStyle = CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout.size(ofValue: alignment), value: &alignment)
            // 换行
            var breakMode = CTLineBreakMode.byTruncatingTail
            let breakModeStyle = CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout.size(ofValue: breakMode), value: &breakMode)
            // 合并成 paragraphStyle
            let settings = [alignmentStyle]
            // FIXME: - 有时会崩在这里
            let numElems = MemoryLayout.size(ofValue: settings) //MemoryLayout.size(ofValue: settings) / MemoryLayout.size(ofValue: settings.first)
            let paragraphStyle = CTParagraphStyleCreate(settings, numElems)
            // 属性字典
            let dic = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 30),
                       NSAttributedStringKey.foregroundColor:UIColor.black,
                       NSAttributedStringKey.paragraphStyle:paragraphStyle] as [NSAttributedStringKey : Any]
            // 要绘制的地点字符串
            let locationStr = NSAttributedString(string: self.title ?? "无名地点", attributes: dic)
            let locationFramesetter = CTFramesetterCreateWithAttributedString(locationStr)
            let locationFrame = CTFramesetterCreateFrame(locationFramesetter, CFRangeMake(0, locationStr.length), locationPath, nil)
            
            // 要绘制的距离字符串
            // TODO: - 处理距离显示
            let distanceStr = NSAttributedString(string: "\(distance)m", attributes: dic)
            let distanceFramesetter = CTFramesetterCreateWithAttributedString(distanceStr)
            let distanceFrame = CTFramesetterCreateFrame(distanceFramesetter, CFRangeMake(0, distanceStr.length), distancePath, nil)
            
            // 绘制
            CTFrameDraw(distanceFrame, ctx)
            CTFrameDraw(locationFrame, ctx)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // 加上背景结点
        let contentGeometry = SCNPlane(width: locationNodeW, height: locationNodeH)
        contentGeometry.firstMaterial?.diffuse.contents = UIColor.white
        contentGeometry.firstMaterial?.transparency = 0.5
        self.geometry = contentGeometry
        
        let bgGeometr = SCNPlane(width: locationNodeW, height: locationNodeH)
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

