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
        addGesture()
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
    
    // MARK: - lazy
    /// 创建漂流瓶结点
    private lazy var bottleNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let color: UIColor = #colorLiteral(red: 0.3411764706, green: 0.9803921569, blue: 1, alpha: 1)
        box.materials.first?.diffuse.contents = color
        box.materials.first?.transparency = 0.5
        let node = SCNNode(geometry: box)
        return node
    }()
    
}

// MARK: - AR显示和交互
extension ARBottleController: ARSCNViewDelegate {
    
    @IBAction func addActionClick(_ sender: Any) {
        SVProgressHUD.showInfo(withStatus: "寻找四周的漂流瓶")
        SVProgressHUD.dismiss(withDelay: 1)
        addBottle()
    }
    
    @objc func tapTest(recognizer: UITapGestureRecognizer) {
        print("tapTest")
        let point = recognizer.location(in: sceneView)
        let results = sceneView.hitTest(point, options: [SCNHitTestOption.boundingBoxOnly : true, SCNHitTestOption.firstFoundOnly: true])
        if let _ = results.first {
            // 瓶子做动画并离开界面
            let scaleOut = SCNAction.scale(by: 2, duration: 0.2)
            let fadeOut = SCNAction.fadeOut(duration: 0.2)
            let group = SCNAction.group([scaleOut, fadeOut])
            let sequence = SCNAction.sequence([group, SCNAction.removeFromParentNode()])
            bottleNode.runAction(sequence) {
                let scaleIn = SCNAction.scale(by: 0.5, duration: 0.1)
                let fadeIn = SCNAction.fadeIn(duration: 0.1)
                let groupIn = SCNAction.group([scaleIn, fadeIn])
                self.bottleNode.runAction(groupIn)
            }
        }
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTest(recognizer:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    private func addBottle() {
        let randNum = drand48() * 2.0
        let r = 1.0
        let x = r * cos(randNum * .pi)
        let z = -r * sin(randNum * .pi)
        print(randNum)
        print(SCNVector3(x, 0, z))
        bottleNode.position = SCNVector3(x, 0, z)
        sceneView.scene.rootNode.addChildNode(bottleNode)
        print(bottleNode)
    }
    
}
