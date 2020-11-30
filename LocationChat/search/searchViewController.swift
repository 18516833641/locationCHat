//
//  searchViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit

class searchViewController: AnalyticsViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    
    //初始化BMKUserLocation的实例
//    var userLocation: BMKUserLocation = BMKUserLocation()
//
//    lazy var mapView: BMKMapView = {
//        let mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
//        //设置mapView的代理
//        mapView.delegate = self
//        return mapView
//    }()
//
//    lazy var locationManager: BMKLocationManager = {
//        //初始化BMKLocationManager的实例
//        let manager = BMKLocationManager()
//        //设置定位管理类实例的代理
//        manager.delegate = self
//        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
//        manager.coordinateType = BMKLocationCoordinateType.BMK09LL
//        //设定定位精度，默认为 kCLLocationAccuracyBest
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
//        manager.activityType = CLActivityType.automotiveNavigation
//        //指定定位是否会被系统自动暂停，默认为NO
//        manager.pausesLocationUpdatesAutomatically = false
//        /**
//         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
//         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
//         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
//         */
//        manager.allowsBackgroundLocationUpdates = false
//        /**
//         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
//         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
//         后开始计算。
//         */
//        manager.locationTimeout = 10
//        return manager
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = nil
        
        loactionAction()
        
        self.view.bringSubviewToFront(topView)
    }


    //MARK:搜索按钮方法
    @IBAction func searchAction(_ sender: Any) {
        
        
    }

    //MARK:定位方法
    func loactionAction() {
//        mapView = BMKMapView(frame: self.view.frame)
//        mapView.delegate = self
//        self.view.addSubview(mapView);
//        
//        
//        // 将当前地图显示缩放等级设置为17级
//        mapView.zoomLevel = 17
//        //显示比例尺
//        mapView.showMapScaleBar = true
////        //隐藏比例尺
////        mapView?.showMapScaleBar = false
//        
//        //切换为标准地图
//        mapView.mapType = BMKMapType.standard
//        
//        //打开实时路况图层
//        mapView.isTrafficEnabled = true
//        
////        //开启定位服务
//        locationManager.startUpdatingHeading()
//        locationManager.startUpdatingLocation()
//        
//        //显示定位图层
//        mapView.showsUserLocation = true
//        
////        //  普通定位模式
//        mapView.userTrackingMode = BMKUserTrackingModeNone
////
////        //定位方向模式
////        mapView.userTrackingMode = BMKUserTrackingModeHeading
////
////        //定位跟随模式
//        mapView.userTrackingMode = BMKUserTrackingModeFollow
        
        //定位罗盘模式
//        mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading
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

//extension searchViewController:BMKLocationManagerDelegate{
//    //MARK:BMKLocationManagerDelegate
//    /**
//     @brief 该方法为BMKLocationManager提供设备朝向的回调方法
//     @param manager 提供该定位结果的BMKLocationManager类的实例
//     @param heading 设备的朝向结果
//     */
//    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
//        NSLog("用户方向更新")
//        userLocation.heading = heading
//        mapView.updateLocationData(userLocation)
//    }
//
//    /**
//     @brief 连续定位回调函数
//     @param manager 定位 BMKLocationManager 类
//     @param location 定位结果，参考BMKLocation
//     @param error 错误信息。
//     */
//    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
//        if let _ = error?.localizedDescription {
//            NSLog("locError:%@;", (error?.localizedDescription)!)
//        }
//        userLocation.location = location?.location
//        //实现该方法，否则定位图标不出现
//        mapView.updateLocationData(userLocation)
//    }
//
//    /**
//     @brief 当定位发生错误时，会调用代理的此方法
//     @param manager 定位 BMKLocationManager 类
//     @param error 返回的错误，参考 CLError
//     */
//    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
//        NSLog("定位失败")
//    }
//
//
//}
