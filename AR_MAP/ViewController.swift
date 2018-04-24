//
//  ViewController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/14.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import SVProgressHUD

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func searchAroundClick(_ sender: Any) {
        demoShowArround()
    }
    
    let margin: CGFloat = 0.15
    var index: CGFloat = 0
    
    @IBOutlet weak var testImage: UIImageView!
    
    var positions: Set<SCNVector3> = Set<SCNVector3>()
    
    func demoShowArround() {
        SVProgressHUD.show(withStatus: "正在定位中...")
        SCLocationManager.shared.arroundSearch { [weak self] (arr) in
            arr.dropLast(15).forEach {
                print($0.name)
                print($0.location)
                let my = SCLocationManager.shared.myLocation
                let target = $0.location!
                let node = BaseNode(title: $0.name, location: CLLocation(latitude: 0, longitude: 0))
                var x = target.longitude - my.longitude
                var z = my.latitude - target.latitude
                x *= 8539 //85390
                z *= 11100 //111000
//                node.position = SCNVector3(x, 0, z)
                
                // 等比例缩放
                let aimDistance: CGFloat = 1.0
                let curDistance = sqrt(pow(x, 2.0) + pow(z, 2.0))
                let scaleAC = aimDistance / curDistance
                x *= scaleAC
                z *= scaleAC
                
                var position = SCNVector3(x, 0.1, z)
                if !(self?.positions.insert(position).inserted)! {
                    
                }
                
                node.position = SCNVector3(x, (self?.index)! * (self?.margin)!, z)
                self?.index += 1
                print(node.position)
                self?.sceneView.scene.rootNode.addChildNode(node)
//                let anchor = ARAnchor(transform: matrix_float4x4.init())
//                self?.sceneView.session.add(anchor: anchor)
            }
            SVProgressHUD.dismiss()
            SVProgressHUD.show(withStatus: "定位完成")
            SVProgressHUD.dismiss()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTest(recognizer:)))
        sceneView.addGestureRecognizer(tap)
        
        demo1()
//        let anchor = ARAnchor(transform: matrix_float4x4.init())
//        self.sceneView.session.add(anchor: anchor)
    }
    
    @objc func tapTest(recognizer: UITapGestureRecognizer) {
        print("tapTest")
        let point = recognizer.location(in: sceneView)
//        let results = sceneView.hitTest(point, types: .existingPlaneUsingExtent)
        let results = sceneView.hitTest(point, options: [SCNHitTestOption.boundingBoxOnly : true, SCNHitTestOption.firstFoundOnly: true])
        results.forEach { (result) in
            if let re = result.node as? BaseNode {
                print("here")
                print(re)
            }
            print(result.node)
            print((result.node as? BaseNode)?.location ?? "空")
            if result.node.isKind(of: BaseNode.self) {
                print("属性：" + (result.node as! BaseNode).title)
            } else {
                print("result不是BaseNode")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.worldAlignment = .gravityAndHeading

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesBegan")
//        guard let touch = touches.first else { return }
//        let point = touch.location(in: sceneView)
//        print("hitTest")
//        let array = sceneView.hitTest(point, types: .existingPlaneUsingExtent)
//        array.forEach { (result) in
//            print("here")
//            print(result)
//        }
    }

    // MARK: - ARSCNViewDelegate
    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
////        let node = BaseNode(title: "测试", location: CLLocation())
////        return node
//        print("here")
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0);
//        let node = SCNNode(geometry: box)
//        return node
//    }
    
 
}

// MARK: - demo
extension ViewController {
    func demo2() {
        let text = SCNText(string: "测试数据", extrusionDepth: 5)
        text.font = UIFont(name: "Copperplate", size: 30)
        text.chamferRadius = 0.5
        text.flatness = 0.3
        text.firstMaterial?.specular.contents = UIColor.blue
        text.firstMaterial?.diffuse.contents = UIColor.yellow
        text.firstMaterial?.shininess = 0.4
        
        let node = SCNNode(geometry: text)
        
        node.position = SCNVector3(0, 0, -0.5)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func demo1() {
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0);
//        let node = SCNNode(geometry: box)
        
        let node = BaseNode(title: "", location: CLLocation())
            
        node.position = SCNVector3(0, 0, -0.5)
        sceneView.scene.rootNode.addChildNode(node)
        
        print(sceneView.anchor(for: node) ?? "没有anchor")
    }
    
    func demo() {
        let myloction = CLLocationCoordinate2D(latitude: 21.1544156167853, longitude: 110.296934265746)
        let targetloction = CLLocationCoordinate2D(latitude: 20, longitude: 110)
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0);
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(targetloction.latitude - myloction.latitude, 0,  myloction.longitude - targetloction.longitude)
        sceneView.scene.rootNode.addChildNode(node)
    }
}
