//
//  SCLocationManager.swift
//  AR_MAP
//
//  Created by SeacenLiu on 2018/4/14.
//  Copyright © 2018年 成. All rights reserved.
//

import Foundation

// Key: a092e82e7d3058c4f26c7e9579c39b23
// 钟海楼
// 110.296934265746
// 21.1544156167853

class SCLocationManager: NSObject {
    static let shared = SCLocationManager()
    
    typealias AMapSearchCallBack = (_ pois: [AMapPOI]) -> ()
    
    // MARK: public
    public var myLocation: AMapGeoPoint = AMapGeoPoint.location(withLatitude: 21.1544156167853, longitude: 110.296934265746)
    
    // MARK: - init
    override init() {
        super.init()
        // 配置Key
        AMapServices.shared().apiKey = "a092e82e7d3058c4f26c7e9579c39b23"
//        locaiton.allowsBackgroundLocationUpdates = true
    }
    
    // MARK: - private
    private let poiTypes = "国家级景点|风景名胜|购物服务|餐饮服务|住宿服务|体育休闲服务|生活服务"
    
    private var searchFinish: AMapSearchCallBack?
    
    /// 搜索用
    private lazy var search: AMapSearchAPI = {
        let s = AMapSearchAPI()
        s!.delegate = self
        return s!
    }()
    
    /// 定位用
    private lazy var locaiton: AMapLocationManager = {
        let m = AMapLocationManager()
        m.desiredAccuracy = kCLLocationAccuracyBest
        m.locationTimeout = 20
        m.reGeocodeTimeout = 20
        return m
    }()
}

// MARK: - search method
extension SCLocationManager {
    public func arroundSearch(finish: @escaping AMapSearchCallBack) {
        searchFinish = finish
        
        locaiton.requestLocation(withReGeocode: false) { (location, regeocode, error) in
            if let err = error {
                print("定位出错了: " + err.localizedDescription)
                return
            }
            if let loc = location {
                self.myLocation = AMapGeoPoint.location(withLatitude: CGFloat(loc.coordinate.latitude), longitude: CGFloat(loc.coordinate.longitude))
                
                let request = AMapPOIAroundSearchRequest()
                request.location = self.myLocation
                request.types = self.poiTypes
                request.sortrule = 0
                request.page = 0
                //        request.requireExtension = true
                
                self.search.aMapPOIAroundSearch(request)
            }
        }
    }
}

// MARK: - AMapSearchDelegate
extension SCLocationManager: AMapSearchDelegate {
    /// 搜索到POI的回调
    internal func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard let finish = searchFinish else { return }
        if response.count == 0 {
            print("没有搜索结果")
            return
        }
        guard let array = response.pois else {
            return
        }
        finish(array)
    }
}
