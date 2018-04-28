//
//  ShowMapController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/28.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit

class ShowMapController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AMapServices.shared().enableHTTPS = true
        
        view.addSubview(mapView)
        
        showUserLocation()
//        showCustomLocation()
        
        mapView.showsCompass = true
        mapView.compassOrigin = CGPoint(x: UIScreen.main.bounds.width-36-10, y: 10)
        mapView.showsScale = true
        mapView.scaleOrigin = CGPoint(x: 10, y: 10)
        
        mapView.setZoomLevel(17.5, animated: true)
    }
    
    // MARK: lazy
    private lazy var mapView: MAMapView = MAMapView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))

}

extension ShowMapController {
    private func addGesture() {
        
    }
}

// MARK: - 小蓝点功能
extension ShowMapController {
    private func showUserLocation() {
        // 如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
    
    private func showCustomLocation() {
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = false
        r.showsHeadingIndicator = true
        r.fillColor = .red
        r.strokeColor = .blue
        r.lineWidth = 2
        mapView.update(r)
    }
}
