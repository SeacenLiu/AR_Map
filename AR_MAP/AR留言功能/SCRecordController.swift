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
        sceneView.showsStatistics = true
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
    
    // MARK: - show view relate
    private var recordView: SCRecordView?
    
    private lazy var dismissTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissRecordTap(gesture:)))
        tap.isEnabled = false
        return tap
    }()
    
    private var selectNode: SCNNode?
    
    // MARK: - AR
    private lazy var sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    private lazy var configuration = ARWorldTrackingConfiguration()
    
}

// MARK: - gesture
private extension SCRecordController {
    @objc func dissmissRecordTap(gesture: UITapGestureRecognizer) {
        if let _ = recordView {
            dismissRecordView()
            // 禁用dismiss手势
            gesture.isEnabled = false
            // 恢复被选中结点
            if let node = selectNode {
                unSelectAction(node: node)
            }
            selectNode = nil
        }
    }
    
    @objc func selectNodeTapAction(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: sceneView)
        let results = sceneView.hitTest(point, options: [SCNHitTestOption.boundingBoxOnly : true, SCNHitTestOption.firstFoundOnly: true])
        if let node = results.first?.node {
            // 选中结点
            selectNode = node
            // 先移除该结点移动动画
            node.removeAction(forKey: "move")
            // 执行被结点被选中动画
            selectAction(node: node)
            // 显示留言视图
            showRecordView()
            // 开启dismiss手势
            dismissTap.isEnabled = true
        }
    }
    
    func addGesture() {
        let nodeTap = UITapGestureRecognizer(target: self, action: #selector(selectNodeTapAction(gesture:)))
        sceneView.addGestureRecognizer(nodeTap)
        sceneView.addGestureRecognizer(dismissTap)
    }
}

// MARK: - set up record view
private extension SCRecordController {
    func showRecordView() {
        let horizontalMargin: CGFloat  = 30
        let verticalMargin: CGFloat = 40
        let width = UIScreen.main.bounds.width - horizontalMargin * 2
        let height = UIScreen.main.bounds.height - verticalMargin * 2
        let rect = CGRect(x: horizontalMargin, y: verticalMargin, width: width, height: height)
        recordView = SCRecordView(frame: rect)
        recordView?.show()
    }
    
    func dismissRecordView() {
        if let _ = recordView {
            recordView?.close()
            recordView = nil
        }
    }
}

// MARK: - set up AR
private extension SCRecordController {
    func addNode() {
        let emptyNode = SCNNode()
        emptyNode.transform = randomTransfrom(distance: 1)
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let color: UIColor = #colorLiteral(red: 0.3411764706, green: 0.9803921569, blue: 1, alpha: 1)
        box.materials.first?.diffuse.contents = color
        box.materials.first?.transparency = 0.5
        let node = SCNNode(geometry: box)
        
        node.position = emptyNode.position
        print(node.position)
        sceneView.scene.rootNode.addChildNode(node)
        
        randomAction(node: node)
    }
    
    func selectAction(node: SCNNode) {
        print("selectAction")
        let scaleOut = SCNAction.scale(by: 2, duration: 0.2)
        let fadeOut = SCNAction.fadeOut(duration: 0.2)
        let group = SCNAction.group([scaleOut, fadeOut])
        node.runAction(group)
    }
    
    func unSelectAction(node: SCNNode) {
        print("unSelectAction")
        let scaleIn = SCNAction.scale(by: 0.5, duration: 0.2)
        let fadeIn = SCNAction.fadeIn(duration: 0.2)
        let group = SCNAction.group([scaleIn, fadeIn])
        node.runAction(group)
    }
    
    func randomAction(node: SCNNode) {
        let emptyNode = SCNNode()
        emptyNode.transform = randomTransfrom(distance: 1)
        let fromPosition = node.position
        let toPosition = emptyNode.position
        let duration = fromPosition.distance(to: toPosition) * 5
        let goAction = SCNAction.move(to: toPosition, duration: duration)
        goAction.timingMode = .easeInEaseOut
        let backAction = SCNAction.move(to: fromPosition, duration: duration)
        backAction.timingMode = .easeInEaseOut
        let sequenceAction = SCNAction.sequence([goAction, backAction])
        let repeatAction = SCNAction.repeatForever(sequenceAction)
        print(emptyNode.position)
        node.runAction(repeatAction, forKey: "move")
//        node.runAction(repeatAction)
    }
    
    func randomAction() {
        // TODO: 随机结点动画
    }
    
    func randomTransfrom(distance: Float) -> SCNMatrix4 {
        let randNumX = Float(drand48() * 2.0)
        let randNumY = Float(drand48() * 2.0)
        print("随机X: \(randNumX) 随机Y: \(randNumY)")
        let translation = SCNMatrix4Translate(SCNMatrix4Identity, 0, 0, distance)
        let xRotation = SCNMatrix4MakeRotation(Float.pi * randNumX, 1, 0, 0)
        let yRotation = SCNMatrix4MakeRotation(Float.pi * randNumY, 0, 1, 0)
        return SCNMatrix4Mult(SCNMatrix4Mult(translation, xRotation), yRotation)
    }
    
}

// MARK: - set up UI
private extension SCRecordController {
    func setupUI() {
        view.backgroundColor = .lightGray
        // 设置导航栏
        loadNavigation()
        // 设置AR界面
        view.addSubview(sceneView)
        // TODO: 其他UI设置
        
    }
    
    func loadNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
