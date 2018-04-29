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
        
        // 添加漂流瓶手势 点一下就出来
//        addGesture()
        
        // 添加持续定位测试功能
//        setupLocationUI()
        
        // 绘制假数据上的经纬度
//        drawLineFromPlist()
        
        // 追踪画点
        traceAnddrawLineSetUI()
    }
    
    // MARK: lazy
    /// 地图控件
    private lazy var mapView: MAMapView = MAMapView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))
    
    /// 开始跟踪按钮
    private lazy var startTraceBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-88, width: 44, height: 44))
        btn.setTitle("开始持续定位", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.sizeToFit()
        return btn
    }()
    /// 停止追踪按钮
    private lazy var endTeaceBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-44, width: 44, height: 44))
        btn.setTitle("结束持续定位", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.sizeToFit()
        return btn
    }()
    
    /// 定位单例
    private lazy var locationManager: AMapLocationManager = {
        let manager = AMapLocationManager()
        manager.delegate = self
        manager.distanceFilter = 10
        return manager
    }()
    
    /// 绘线假数据
    private var data = LocationData()
    
    /// 绘线真数据
    private var routePoints = [CLLocationCoordinate2D]()
    /// 开始追踪绘线按钮
    private lazy var startTraceLineBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 300, width: 44, height: 44))
        btn.setTitle("开始追踪", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.white, for: .disabled)
        btn.sizeToFit()
        return btn
    }()
    /// 结束追踪绘线按钮
    private lazy var endTraceLineBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 330, width: 44, height: 44))
        btn.setTitle("结束追踪", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.white, for: .disabled)
        btn.sizeToFit()
        return btn
    }()
    /// 清空路线
    private lazy var clearTraceLineBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 360, width: 44, height: 44))
        btn.setTitle("清除路线", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.white, for: .disabled)
        btn.sizeToFit()
        return btn
    }()
    /// 追踪路线
    private var traceLine: MAPolyline?
    
}

// MARK: - 绘制折线
extension ShowMapController {
    @objc private func startTraceAndDrawLine() {
        // 0. UI处理
        SVProgressHUD.showSuccess(withStatus: "开始追踪")
        SVProgressHUD.dismiss(withDelay: 1)
        startTraceLineBtn.isEnabled = false
        endTraceLineBtn.isEnabled = true
        // 1. 打开持续定位
        locationManager.startUpdatingLocation()
        // 2. 刷新点
        routePoints.removeAll()
        // 3. 代理中调用绘线
    }
    
    @objc private func endTraceAndDrawLine() {
        // 0. UI处理
        SVProgressHUD.showSuccess(withStatus: "结束追踪")
        SVProgressHUD.dismiss(withDelay: 1)
        startTraceLineBtn.isEnabled = true
        endTraceLineBtn.isEnabled = false
        clearTraceLineBtn.isEnabled = true
        // 1. 停止跟踪
        locationManager.stopUpdatingLocation()
        // 2. 保存追踪的点
        LocationData.saveLocationData(arr: routePoints)
    }
    
    @objc private func clearTraceLine() {
        // 0. UI处理
        SVProgressHUD.showSuccess(withStatus: "清除路线")
        SVProgressHUD.dismiss(withDelay: 1)
        clearTraceLineBtn.isEnabled = false
        // 1. 清除路线
        if let overlay = traceLine {
            mapView.remove(overlay)
        }
        routePoints.removeAll()
    }
    
    private func traceAnddrawLineSetUI() {
        // addSubView
        view.addSubview(startTraceLineBtn)
        view.addSubview(endTraceLineBtn)
        view.addSubview(clearTraceLineBtn)
        // addTarget
        startTraceLineBtn.addTarget(self, action: #selector(startTraceAndDrawLine), for: .touchUpInside)
        endTraceLineBtn.addTarget(self, action: #selector(endTraceAndDrawLine), for: .touchUpInside)
        clearTraceLineBtn.addTarget(self, action: #selector(clearTraceLine), for: .touchUpInside)
        // init UI
        startTraceLineBtn.isEnabled = true
        endTraceLineBtn.isEnabled = false
        clearTraceLineBtn.isEnabled = false
    }
    
    /// 绘制Plist中的线
    private func drawLineFromPlist() {
        var lineCoordinates = [CLLocationCoordinate2D]()
        let path = Bundle.main.path(forResource: "pointData", ofType: "plist")
        if let points = NSArray(contentsOfFile: path!) {
            points.forEach {
                if let point = $0 as? [String: Double] {
                    let coordinate = CLLocationCoordinate2D(latitude: point["latitude"]!, longitude: point["longitude"]!)
                    lineCoordinates.append(coordinate)
                }
            }
        } else {
            print("读取数据失败")
        }
        let polyline: MAPolyline = MAPolyline(coordinates: &lineCoordinates, count: UInt(lineCoordinates.count))
        mapView.add(polyline)
    }
    
}

// MARK: - 持续定位代理
extension ShowMapController: AMapLocationManagerDelegate {
    private func setupLocationUI() {
        view.addSubview(startTraceBtn)
        view.addSubview(endTeaceBtn)
        startTraceBtn.addTarget(self, action: #selector(startContinueLocation), for: .touchUpInside)
        endTeaceBtn.addTarget(self, action: #selector(endLocation), for: .touchUpInside)
        
        endTeaceBtn.isEnabled = false
        startTraceBtn.isEnabled = true
    }
    
    @objc private func startContinueLocation() {
        SVProgressHUD.showSuccess(withStatus: "开始持续定位")
        SVProgressHUD.dismiss(withDelay: 1)
        locationManager.startUpdatingLocation()
        endTeaceBtn.isEnabled = true
        startTraceBtn.isEnabled = false
    }
    
    @objc private func endLocation() {
        SVProgressHUD.showSuccess(withStatus: "结束持续定位")
        SVProgressHUD.dismiss(withDelay: 1)
        locationManager.stopUpdatingLocation()
        endTeaceBtn.isEnabled = false
        startTraceBtn.isEnabled = true
        
        data.saveToPlist()
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        /// 绘制追踪路线的思路
        // 1. 添加新元素到经纬度数组
        routePoints.append(location.coordinate)
        // 2. 重新绘制
        if let overlay = traceLine {
            mapView.remove(overlay)
        }
        traceLine = MAPolyline(coordinates: &routePoints, count: UInt(routePoints.count))
        mapView.add(traceLine)
        
        /** 测试持续定位的代码
        print("当前位置: \(location.coordinate.latitude) , \(location.coordinate.longitude)")
        SVProgressHUD.showSuccess(withStatus: "\(location.coordinate.latitude) , \(location.coordinate.longitude)")
        SVProgressHUD.dismiss(withDelay: 2)
        data.addData(location: location.coordinate)
         */
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
    
    /// 改变绘线的样式
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.cyan
            return renderer
        }
        return nil
    }
    
    /// 显示大头针的样式
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
