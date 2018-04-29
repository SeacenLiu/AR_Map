//
//  ARBottleController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/29.
//  Copyright © 2018年 成. All rights reserved.
//

import ARKit
import SVProgressHUD

class ARBottleController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        addBottle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.showInfo(withStatus: "寻找四周的漂流瓶")
        SVProgressHUD.dismiss(withDelay: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}

// MARK: - AR显示和交互
extension ARBottleController: ARSCNViewDelegate {
    
    private func addBottle() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let color: UIColor = #colorLiteral(red: 0.3411764706, green: 0.9803921569, blue: 1, alpha: 1)
        box.materials.first?.diffuse.contents = color
        box.materials.first?.transparency = 0.5
        let node = SCNNode(geometry: box)
        sceneView.scene.rootNode.addChildNode(node)
        let randNum = Double(arc4random())
        let r = 1.0
        let x = r * cos(randNum * .pi)
        let z = r * sin(randNum * .pi)
        node.position = SCNVector3(x, 0, z)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        let transform = matrix_float4x4()
        //        let anchor = ARAnchor(transform: transform)
        //        sceneView.session.add(anchor: anchor)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        let color: UIColor = #colorLiteral(red: 0.3411764706, green: 0.9803921569, blue: 1, alpha: 1)
//        box.materials.first?.diffuse.contents = color
//        box.materials.first?.transparency = 0.5
//        let node = SCNNode(geometry: box)
//        print(node)
//        print(anchor.transform)
//        return node
//    }
}
