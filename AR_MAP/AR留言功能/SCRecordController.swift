//
//  SCRecordController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/5/3.
//  Copyright © 2018年 成. All rights reserved.
//

import ARKit

class SCRecordController: UIViewController {

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addNode()
            self.addGesture()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - AR
    private lazy var sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    private lazy var configuration = ARWorldTrackingConfiguration()
    
}

// MARK - set up AR
private extension SCRecordController {
    func addNode() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let color: UIColor = #colorLiteral(red: 0.3411764706, green: 0.9803921569, blue: 1, alpha: 1)
        box.materials.first?.diffuse.contents = color
        box.materials.first?.transparency = 0.5
        let node = SCNNode(geometry: box)
        
        node.transform = randomTransfrom(distance: 1)
        print(node.position)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        randomAction(node: node)
    }
    
    func selectAction(node: SCNNode) {
        let scaleOut = SCNAction.scale(by: 2, duration: 0.2)
        let fadeOut = SCNAction.fadeOut(duration: 0.2)
        let group = SCNAction.group([scaleOut, fadeOut])
        let sequence = SCNAction.sequence([group, SCNAction.removeFromParentNode()])
        node.runAction(sequence)
    }
    
    func unSelectAction(node: SCNNode) {
        let scaleIn = SCNAction.scale(by: 2, duration: 0.2)
        let fadeIn = SCNAction.fadeOut(duration: 0.2)
        let group = SCNAction.group([scaleIn, fadeIn])
        let sequence = SCNAction.sequence([group, SCNAction.removeFromParentNode()])
        node.runAction(sequence)
    }
    
    func randomAction(node: SCNNode) {
        let nullNode = SCNNode()
        nullNode.transform = randomTransfrom(distance: 1)
        let fromPosition = node.position
        let toPosition = nullNode.position
        let duration = fromPosition.distance(to: toPosition) * 5
        let goAction = SCNAction.move(to: toPosition, duration: duration)
        goAction.timingMode = .easeInEaseOut
        let backAction = SCNAction.move(to: fromPosition, duration: duration)
        backAction.timingMode = .easeInEaseOut
        let sequenceAction = SCNAction.sequence([goAction, backAction])
        let repeatAction = SCNAction.repeatForever(sequenceAction)
        print(nullNode.position)
        node.runAction(repeatAction)
    }
    
    func randomAction() {
        
    }
    
    func randomTransfrom(distance: Float) -> SCNMatrix4 {
        let randNumX = Float(drand48() * 2.0)
        let randNumY = Float(drand48() * 2.0)
        let translation = SCNMatrix4Translate(SCNMatrix4Identity, 0, 0, distance)
        let xRotation = SCNMatrix4MakeRotation(Float.pi * randNumX, 1, 0, 0)
        let yRotation = SCNMatrix4MakeRotation(Float.pi * randNumY, 0, 1, 0)
        return SCNMatrix4Mult(SCNMatrix4Mult(translation, xRotation), yRotation)
    }
    
    @objc func selectNodeTapAction(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: sceneView)
        let results = sceneView.hitTest(point, options: [SCNHitTestOption.boundingBoxOnly : true, SCNHitTestOption.firstFoundOnly: true])
        if let node = results.first?.node {
            node.removeAllActions()
            selectAction(node: node)
        }
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectNodeTapAction(gesture:)))
        sceneView.addGestureRecognizer(tap);
    }
    
}

extension SCNVector3 {
    func distance(to anotherVector: SCNVector3) -> Double {
        return Double(sqrt(pow(anotherVector.x - x, 2) + pow(anotherVector.z - z, 2) + pow(anotherVector.y - y, 2)))
    }
}

// MARK - set up UI
private extension SCRecordController {
    func setupUI() {
        view.backgroundColor = .lightGray
        // 设置导航栏
        loadNavigation()
        // 设置AR界面
        view.addSubview(sceneView)
        // 其他UI设置
        
    }
    
    func loadNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
