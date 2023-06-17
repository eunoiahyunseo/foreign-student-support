//
//  MapView.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by 정원준 on 2023/06/16.
//  Copyright © 2023 iOS App Templates. All rights reserved.
//

import Foundation
import SwiftUI
import NMapsMap
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject{
    var locationManager = CLLocationManager()
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    override init(){
        super.init()
        
        // 델리게이트를 설정하고,
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            print("위치 서비스 허용 off")
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            latitude = location.coordinate.latitude
            print("경도 : \(location.coordinate.longitude)")
            longitude = location.coordinate.longitude
        }
    }
        
    // 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
}

struct MapView: UIViewRepresentable {
    @Binding var sendMsg: Bool
    @Binding var name: String
    typealias NMFOverlayTouchHandler = (NMFOverlay) -> Bool
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let handler: NMFOverlayTouchHandler = { (overlay) -> Bool in
            self.sendMsg = true
            self.name = overlay.userInfo["friend"] as! String
            print("마커 \(overlay.userInfo["friend"] ?? "tag") 터치됨")
            return false
        }
        
        //let locationManager = LocationManager()
        //locationManager.stopUpdatingLocation()
        
        //let viewController = UIViewController()
        
        let marker = NMFMarker()
        let marker2 = NMFMarker()
        let marker3 = NMFMarker()
        let mapView = NMFNaverMapView()
        mapView.showZoomControls = true
        mapView.showLocationButton = true
        mapView.showCompass = true
        mapView.positionMode = .direction
        //let mapView = NMFMapView(frame: viewController.view.frame)
        //mapView.positionMode = .direction
        //let image = NMFOverlayImage(name: "orem")
        
        marker.position = NMGLatLng(lat: 35.884772, lng: 128.613962)
        marker.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker.captionText = "친구1"
        marker.captionColor = UIColor.red
        marker.userInfo = ["friend": "친구1"]
        marker.touchHandler = handler
        
        marker2.position = NMGLatLng(lat: 35.8850756, lng: 128.6099425)
        marker2.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker2.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker2.captionText = "친구2"
        marker2.captionColor = UIColor.red
        marker2.userInfo = ["friend": "친구2"]
        marker2.touchHandler = handler
        
        marker3.position = NMGLatLng(lat: 35.8918744, lng: 128.6098171)
        marker3.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker3.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        marker3.captionText = "친구3"
        marker3.captionColor = UIColor.red
        marker3.userInfo = ["friend": "친구3"]
        marker3.touchHandler = handler
        
        //marker.iconImage = image
        marker.mapView = mapView.mapView
        marker2.mapView = mapView.mapView
        marker3.mapView = mapView.mapView
        //viewController.view.addSubview(mapView)
        //viewController.view.addSubview(mapCtrl)
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        // Update the view controller if needed
    }
        
//    func updateUIView(_ uiViewController: UIViewController, context: Context) {
//        // Update the view controller if needed
//    }
        
    //typealias UIViewControllerType = UIViewController
    
}
