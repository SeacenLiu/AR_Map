//
//  ShowMapController.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/28.
//  Copyright © 2018年 成. All rights reserved.
//

import UIKit
import SVProgressHUD

class ShowMapController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AMapServices.shared().enableHTTPS = true
        
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        showUserLocation()
//        showCustomLocation()
        
        mapView.showsCompass = true
        mapView.compassOrigin = CGPoint(x: UIScreen.main.bounds.width-36-10, y: 10)
        mapView.showsScale = true
        mapView.scaleOrigin = CGPoint(x: 10, y: 10)
        
        mapView.setZoomLevel(17.5, animated: true)
        
        addGesture()
        
        setupLocationUI()
    }
    
    // MARK: lazy
    private lazy var mapView: MAMapView = MAMapView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))
    
    private lazy var startBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-88, width: 44, height: 44))
        btn.setTitle("开始持续定位", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.sizeToFit()
        return btn
    }()
    
    private lazy var endBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-44, width: 44, height: 44))
        btn.setTitle("结束持续定位", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.sizeToFit()
        return btn
    }()
    
    private lazy var locationManager: AMapLocationManager = {
        let manager = AMapLocationManager()
        manager.delegate = self
        manager.distanceFilter = 1
        return manager
    }()

}

// MARK: - 持续定位代理
extension ShowMapController: AMapLocationManagerDelegate {
    private func setupLocationUI() {
        view.addSubview(startBtn)
        view.addSubview(endBtn)
        startBtn.addTarget(self, action: #selector(startContinueLocation), for: .touchUpInside)
        endBtn.addTarget(self, action: #selector(endLocation), for: .touchUpInside)
        
        endBtn.isEnabled = false
        startBtn.isEnabled = true
    }
    
    @objc private func startContinueLocation() {
        SVProgressHUD.showSuccess(withStatus: "开始持续定位")
        SVProgressHUD.dismiss(withDelay: 1)
        locationManager.startUpdatingLocation()
        endBtn.isEnabled = true
        startBtn.isEnabled = false
    }
    
    @objc private func endLocation() {
        SVProgressHUD.showSuccess(withStatus: "结束持续定位")
        SVProgressHUD.dismiss(withDelay: 1)
        locationManager.stopUpdatingLocation()
        endBtn.isEnabled = false
        startBtn.isEnabled = true
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        print("当前位置: \(location.coordinate.latitude) , \(location.coordinate.longitude)")
        SVProgressHUD.showSuccess(withStatus: "\(location.coordinate.latitude) , \(location.coordinate.longitude)")
        SVProgressHUD.dismiss(withDelay: 2)
    }
}

// MARK: - 单击手势
extension ShowMapController: UIGestureRecognizerDelegate {
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let touchPoint = gesture.location(in: mapView)
            let annotation = MAPointAnnotation()
            let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            annotation.coordinate = touchMapCoordinate
            print(touchMapCoordinate)
            annotation.title = "测试"
            mapView.addAnnotation(annotation)
        }
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(gesture:)))
        tap.delegate = self
        mapView.addGestureRecognizer(tap)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - MAMapViewDelegate
extension ShowMapController: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            // 大头针
//            annotationView!.canShowCallout = true
//            annotationView!.animatesDrop = true
//            annotationView!.isDraggable = true
//            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
//            annotationView!.pinColor = MAPinAnnotationColor(rawValue: 1)!
            
            // 自定义贴图
            annotationView!.image = UIImage(named: "bottle.png")
            annotationView!.centerOffset = CGPoint(x: 0, y: -18)
            
            return annotationView!
        }
        return nil
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
