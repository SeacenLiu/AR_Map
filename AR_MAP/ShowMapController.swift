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
        
        mapView.delegate = self
        
        showUserLocation()
//        showCustomLocation()
        
        mapView.showsCompass = true
        mapView.compassOrigin = CGPoint(x: UIScreen.main.bounds.width-36-10, y: 10)
        mapView.showsScale = true
        mapView.scaleOrigin = CGPoint(x: 10, y: 10)
        
        mapView.setZoomLevel(17.5, animated: true)
        
        addGesture()
    }
    
    // MARK: lazy
    private lazy var mapView: MAMapView = MAMapView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))

}

extension ShowMapController: UIGestureRecognizerDelegate {
    @objc func longPress(gesture: UITapGestureRecognizer) {
        if gesture.state == .began {
            print("began")
        } else if gesture.state == .changed {
            print("changed")
        } else if gesture.state == .ended {
            print("ended")
        }
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        tap.delegate = self
        mapView.addGestureRecognizer(tap)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ShowMapController: MAMapViewDelegate {
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            annotationView!.pinColor = MAPinAnnotationColor(rawValue: 1)!
            
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
