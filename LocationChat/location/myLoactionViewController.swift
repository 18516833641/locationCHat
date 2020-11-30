//
//  myLoactionViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
//

import UIKit

class myLoactionViewController: AnalyticsViewController {
    
    @IBOutlet weak var topView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我的轨迹"
        
        loactionAction()
        
        self.view.bringSubviewToFront(topView)
        
    }

    @IBAction func startTimeAction(_ sender: Any) {
    }
    
    @IBAction func endTimeAction(_ sender: Any) {
        
    }
    
    @IBAction func myLoactionAction(_ sender: Any) {
        
    }
    //MARK:定位方法
    func loactionAction() {
        
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.zoomLevel = 14
        mapView.userTrackingMode = .follow
//        mapView.isShowsUserLocation = true
        self.view.addSubview(mapView)
        
        
        let locationManager = AMapLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 100//设置定位最小更新距离方法如下，单位米
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locationTimeout = 10
        locationManager.reGeocodeTimeout = 10
        locationManager.allowsBackgroundLocationUpdates = true

        locationManager.locatingWithReGeocode = true
        if UIDevice.current.systemVersion._bridgeToObjectiveC().doubleValue >= 9.0 {
            locationManager.pausesLocationUpdatesAutomatically = true
        }
        locationManager.startUpdatingLocation()
//        mapView.addSubview(locationManager.allowsBackgroundLocationUpdates)


    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        mapView.viewWillAppear()
//        self.hidesBottomBarWhenPushed = false
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        mapView.viewWillDisappear()
//    }

}

extension myLoactionViewController:MAMapViewDelegate,AMapLocationManagerDelegate{
    //MARK:MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
//        print(error)
    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        print("--------\(String(describing: userLocation.location))")
        
    }
    
//    func mapViewDidStopLocatingUser(_ mapView: MAMapView!) {
//        mapView.userLocation.location
//        print("-----\(mapView.userLocation.location)")
//    }
  
   
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        
    }
    
    //MARK:AMapLocationManagerDelegate
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
//        print("-----定位：\(location)")
        print("-----坐标:\(location.coordinate)")
        print("-----精度:\(location.horizontalAccuracy)")
    }
    
    //发生错误会调次方法
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        print(error as Any)
    }
 

}

