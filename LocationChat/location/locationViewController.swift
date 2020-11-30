
//  locationViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit
import MMDrawerController
import SwiftyJSON


class locationViewController: AnalyticsViewController{
    
 
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myTime: UILabel!
    @IBOutlet weak var myLocation: UILabel!
    //    var clousre : MKPositioningClosure?
    let locationManager = AMapLocationManager()
    
    let option = AMapTrackManagerOptions()
    var trackManagerCopy = AMapTrackManager()
    
    var serviceID = ""//服务id
    var termiID = ""//设备id
    var trackidID = ""//轨迹id
    
    var userPhone = ""
    var nickName = ""
    
    
    
    
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "手机定位"

        //定位开启
        loactionAction()
        
        //创建轨迹服务
        createServiceAction()
    
        setLeftNavigationButton()
        
        setRightNavigationButton()
        
        let vc:leftRootViewController = self.mm_drawerController.leftDrawerViewController as! leftRootViewController

        vc.delegate = self
        
        self.view.bringSubviewToFront(topView)
        
        // 启用计时器，控制每秒执行一次tickDown方法
//        timer = Timer.scheduledTimer(timeInterval: 10,target:self,selector:#selector(tickDown),userInfo:nil,repeats:true)
        
        let user = BmobUser.current()

        let vip = user?.object(forKey: "vip")
        userPhone = user?.mobilePhoneNumber ?? ""
        nickName = user?.object(forKey: "nickName") as! String
        
        if vip as! String == "1" {//已经开通vip
            
         
            CreateTrackAction()
            
        }else if vip as! String == "0"{//未开通vip
           
//            CreateServiceAction()
           
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()

    }
    
    /**
       *计时器每秒触发事件
       **/
    @objc func tickDown()
       {
           print("tick...")
//        locationManager.startUpdatingLocation()
       }
    
    func setLeftNavigationButton() {
        
        let leftBarButton:MMDrawerBarButtonItem = MMDrawerBarButtonItem(target: self, action: #selector(leftDrawerButtonPress( _: )))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setRightNavigationButton() {

        let masssageButton = UIButton()
        masssageButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        masssageButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        masssageButton.setBackgroundImage(UIImage(named: "loaction_massage"), for: .normal)
        masssageButton.addTarget(self, action: #selector(rightBarAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: masssageButton)
        
    }
    
    
    @objc func leftDrawerButtonPress(_ barButtonItem:MMDrawerBarButtonItem) {
        //print("左边 导航栏 按钮点击")
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @objc func rightBarAction() {
        
        let vc = massageViewController()
   
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    //MARK:我的轨迹
    @IBAction func myLoactionAction(_ sender: Any) {

        startTrackServer()
//        let vc = myLoactionViewController()
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK:定位
    func loactionAction() {
        
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.zoomLevel = 13
        mapView.userTrackingMode = .follow
        mapView.isShowsUserLocation = true
        self.view.addSubview(mapView)
        
        
        
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
        


    }
    
    //MARK:轨迹上传
    func TrackAction() {
        
        
        
    }
    
    //MARK:创建服务
    func createServiceAction() {
        
        let parameters = ["key":"d038b6c3e0793c5ac2e0d4d4d589b3f8" as AnyObject,//请求服务权限标识
                     "name":"phone_Location_service" as AnyObject,//服务名称
                     "desc":"手机定位轨迹回放标识符" as AnyObject]//服务描述

        BKHttpTool.requestData(requestType: .Post, URLString: "https://tsapi.amap.com/v1/track/service/add", parameters: parameters) { (error, response) in


            if error == nil , let data = response{

                let json = JSON(data)
                
                if json["errcode"].stringValue == "20009" {//service已存在
                    
                    self.requestServiceAction()
                    
                }else{
                    
                    self.serviceID = json["data"]["sid"].stringValue
                    self.CreateTrackAction()
                    
                }

            }

        } failured: { (error, response) in

        }

    }
    
    //MARK:查询serviceID是否存在
    func requestServiceAction() {
        
        let param = ["key":"d038b6c3e0793c5ac2e0d4d4d589b3f8" as AnyObject]//请求服务权限标识

        BKHttpTool.requestData(requestType: .Get, URLString: "https://tsapi.amap.com/v1/track/service/list", parameters: param) { (error, response) in


            if error == nil , let data = response{

                let json = JSON(data)

                print("\(json)")

                self.serviceID = json["data"]["results"][0]["sid"].stringValue
                
                self.creatTerminalID()
                self.CreateTrackAction()

                print("------------\(self.serviceID)")
            }

        } failured: { (error, response) in

        }

    }
    
    //MARK:创建终端服务id
    func creatTerminalID() {
        
        let parameters = ["key":"d038b6c3e0793c5ac2e0d4d4d589b3f8" as AnyObject,//请求服务权限标识
                     "sid":self.serviceID as AnyObject,//服务名称
                     "name":userPhone as AnyObject,
                     "desc":"终端" as AnyObject]//服务描述

        BKHttpTool.requestData(requestType: .Post, URLString: "https://tsapi.amap.com/v1/track/terminal/add", parameters: parameters) { (error, response) in


            if error == nil , let data = response{

                let json = JSON(data)
                
                print("--------\(json)")
                self.termiID = json["data"]["sid"].stringValue
                
//                if json["errcode"].stringValue == "20009" {//service已存在
//
//                    self.requestServiceAction()
//
//                }else{
//
//
//                    self.CreateTrackAction()
//
//                }

            }

        } failured: { (error, response) in

        }
        
    }
    
    
    //MARK:开启轨迹服务
    func startTrackServer() {
        //开始服务
        let serviceOption = AMapTrackManagerServiceOption()
        serviceOption.terminalID = "15661004819"
    
        trackManagerCopy.startService(withOptions: serviceOption)
        
    }
    
    //MARK:关闭轨迹服务（先关闭轨迹采集，再关闭服务）
    func stopTrackServer() {
        //关闭轨迹采集
        self.trackManagerCopy.stopGaterAndPack()
        
        //关闭轨迹服务
        self.trackManagerCopy.stopService()
        
        self.trackManagerCopy.delegate = nil
        
    }
    
    //MARK:开始轨迹采集
    func startTrackGather() {
        let userDefault = UserDefaults.standard
        let trackID = userDefault.object(forKey: "trackID") as? String
        
        if trackID == nil{
            //轨迹id不存在，创建轨迹id
            CreateTrackName()
        }else{
            //轨迹id已存在，直接开始采集
            self.trackManagerCopy.startGatherAndPack()
            
            //上传轨迹
            //这里轨迹已经开始采集成功，请求后台接口上传相关的数据
        }

        
        
    }
    
    //MARK:创建终端id
    func CreateTrackAction() {
        
//        changeGatherAndPackTimeInterval
        option.serviceID = self.serviceID
        
        
        //初始化AMapTrackManager
        let trackManager = AMapTrackManager.init(options: option)
        trackManagerCopy = trackManager
        trackManagerCopy.delegate = self
    
        //将定位信息采集周期设置为10s，上报周期设置为30s
        trackManagerCopy.changeGatherAndPackTimeInterval(1, packTimeInterval: 3)
//        trackManager.setLocalCacheMaxSize(50)//设定允许的本地缓存最大值
        
        //配置定位属性
        trackManagerCopy.allowsBackgroundLocationUpdates = true//是否允许后台定位。
        trackManagerCopy.pausesLocationUpdatesAutomatically = false//指定定位是否会被系统自动暂停。默认为NO。
        
        //查询终端是否存在
        let request = AMapTrackQueryTerminalRequest()
        request.serviceID = trackManagerCopy.serviceID
        request.terminalID = "15661004819" //根据用户名创建终端id
        
        trackManagerCopy.aMapTrackQueryTerminal(request)
        
        
        
        
    }
    
    
    
    //MARK:创建轨迹ID
    func CreateTrackName() {
        
        if trackManagerCopy == nil {
            
            return
        }
        
        print("创建轨迹id")
        let request = AMapTrackAddTrackRequest()
        request.serviceID = trackManagerCopy.serviceID
        request.terminalID = trackManagerCopy.terminalID
        trackManagerCopy.aMapTrackAddTrack(request)
        
    }
    
    
   
    
    
    //MARK:获取当前时间
    func currentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm"// 自定义时间格式
        // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }
    
    @IBAction func chakanACtion(_ sender: Any) {
        requestTrack()
    }
    //MARK:查询历史轨迹
    func requestTrack() {
        
        let request = AMapTrackQueryTrackHistoryAndDistanceRequest()
        
        request.serviceID = self.trackManagerCopy.serviceID
//        request.terminalID = self.trackManagerCopy.serviceID
        let millisecond = Date().milliStamp
        request.startTime = Int64(Int(millisecond)! - 12 * 60 * 60)
        request.endTime = Int64(millisecond)!
        self.trackManagerCopy.aMapTrackQueryTrackHistoryAndDistance(request)
        
    }

}

extension locationViewController:MAMapViewDelegate,AMapLocationManagerDelegate,AMapTrackManagerDelegate{
    
    
    //MARK:MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
//        print(error)
    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
//        print("--------\(String(describing: userLocation.location))")

    }
  
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
   
    }
    
    //MARK:AMapLocationManagerDelegate
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        print(error as Any)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {

//        print("-----坐标:\(location.coordinate.latitude)")
        if let reGeocode = reGeocode {
            NSLog("reGeocode:%@", reGeocode)
            myLocation.text = reGeocode.formattedAddress
            myTime.text = currentTime()
        }
    }
    
    
    //MARK:AMapTrackManagerDelegate
    func amapTrackManager(_ manager: AMapTrackManager, doRequireTemporaryFullAccuracyAuth locationManager: CLLocationManager, completion: @escaping (Error) -> Void) {
        
    }
    
    //查询终端结果
    func onQueryTerminalDone(_ request: AMapTrackQueryTerminalRequest, response: AMapTrackQueryTerminalResponse) {
        
        
        print("=======\(response.terminals)")
        
        if response.terminals.count  > 0 {

            //查询到结果，使用terminal ID
            let terminalID = response.terminals.first?.tid
            print("查询到结果======\(String(describing: terminalID))")
            self.termiID = terminalID ?? ""

            //启动轨迹上报服务
            startTrackServer()
        }else{

            //查询结果为空，创建新的terminal
            let addRequest = AMapTrackAddTrackRequest()
            addRequest.serviceID = trackManagerCopy.serviceID
            addRequest.terminalID = "15661004819"//根据用户名去创建id
            trackManagerCopy.aMapTrackQueryTerminal(request)

        }
    }
    
    //创建终端结果
    func onAddTerminalDone(_ request: AMapTrackAddTerminalRequest, response: AMapTrackAddTerminalResponse) {
        //创建terminal成功
        termiID = response.terminalID
        
        //启动上报服务(service id)
        startTrackServer()
        print("创建terminal成功，启动上报服务(service id)\(termiID)")
    }
    
    //错误回调
    func didFailWithError(_ error: Error, associatedRequest request: Any) {
        
        if request is AMapTrackQueryTerminalRequest{
            print("查询参数错误\(error)")
        }
        if request is AMapTrackAddTrackRequest {
            print("创建terminal失败\(error)")
        }
        if request is AMapTrackQueryTrackHistoryAndDistanceRequest {
            print("查询历史轨迹失败\(error)")
            
        }
    }
    

    //生成轨迹id
    func onAddTrackDone(_ request: AMapTrackAddTrackRequest, response: AMapTrackAddTrackResponse) {
        
        print("onAddTrackDone\(response.formattedDescription())")
        
        if response.code == AMapTrackErrorCode.OK {
            //创建trackID成功，开始采集
            self.trackManagerCopy.trackID = response.trackID
            
            print("轨迹id------\(response.trackID)")
            
            //在巡检过程中杀死应用后，需要重启上报服务，但轨迹id被清空，不能继续开始轨迹采集，所以需要本地存储，巡检结束后删除
            
            let userDefault = UserDefaults.standard
            userDefault.set(response.trackID, forKey: "trackID")
            userDefault.synchronize()

            
            self.trackManagerCopy.startGatherAndPack()
            
            //上传轨迹
            //这里轨迹已经开始采集成功，请求后台接口上传相关的数据
            
        }else{
            
            print("创建trackID失败")
        }
    }
    
    //查询轨迹历史数据和行驶距离回调函数
    func onQueryTrackHistoryAndDistanceDone(_ request: AMapTrackQueryTrackHistoryAndDistanceRequest, response: AMapTrackQueryTrackHistoryAndDistanceResponse) {
        print("查询历史轨迹\(response.formattedDescription())")
    }
    
    //service 开启结果回调 开始Service回调
    func onStartService(_ errorCode: AMapTrackErrorCode) {
        if errorCode == AMapTrackErrorCode.OK {
//            trackManagerCopy.startGatherAndPack()
            startTrackServer()
            print("开始轨迹服务成功")
            
            //服务成功后，开始轨迹采集
            startTrackGather()
            
        }else{
            print("开始轨迹服务失败")
        }
    }
    func onStopService(_ errorCode: AMapTrackErrorCode) {
        if errorCode == AMapTrackErrorCode.OK {
            print("关闭轨迹服务成功")
        }else{
            print("关闭轨迹服务失败")
        }
    }
    
    
    //gather 开始轨迹采集和上传回调
    func onStartGatherAndPack(_ errorCode: AMapTrackErrorCode) {
        if errorCode == AMapTrackErrorCode.OK {
            print("开始轨迹采集成功")
        }else{
            print("开始轨迹采集失败")
        }
    }
    
    //gather 关闭轨迹采集和上传回调
    func onStopGatherAndPack(_ errorCode: AMapTrackErrorCode) {
        if errorCode == AMapTrackErrorCode.OK {
            print("关闭轨迹采集成功")
        }else{
            print("关闭轨迹采集失败")
        }
    }

}





extension Date {

   /// 获取当前 秒级 时间戳 - 10位
   var timeStamp : String {
       let timeInterval: TimeInterval = self.timeIntervalSince1970
       let timeStamp = Int(timeInterval)
       return "\(timeStamp)"
   }

   /// 获取当前 毫秒级 时间戳 - 13位
   var milliStamp : String {
       let timeInterval: TimeInterval = self.timeIntervalSince1970
       let millisecond = CLongLong(round(timeInterval*1000))
       return "\(millisecond)"
   }
}






extension locationViewController:LeftViewControllerDelegate{
    func pushToNewViewController(index: Int) {
        /// first close drawer
        self.mm_drawerController.closeDrawer(animated: true) { (complete) in
            //也可以在这里面 push
        }
        
        switch index {
        case 0:do {//家人守护
            
            let vc = homeViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
                
            }
        
        case 1:do {//意见反馈
            
            let vc = feedbackViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
                
            }
        case 2:do {//位置权限
            
            let settingURL = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(settingURL!){
              UIApplication.shared.openURL(settingURL!)
            }
                
            }
        
        case 3:do {//清除缓存
            
            
            let result = "温馨提示"
            let alertController = UIAlertController(title: result, message: "确认清楚缓存嘛？", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)

            alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (UIAlertAction) in
                
                SVProgressHUD.show(withStatus: "清除缓存成功")
                SVProgressHUD.dismiss(withDelay: 0.75)
                
            }))
            alertController.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
            
            
                
            }
        
        case 4:do {//关于我们
            
            let vc = xieyiViewController()
            
            self.navigationController?.pushViewController(vc, animated: false)
    
                
            }
        
        case 5:do {//注销账户
            
            let vc = cancelViewController()
           
            vc.title = "注销账户"
            self.navigationController?.pushViewController(vc, animated: false)
                
            }
        
        case 6:do {//退出登录
            let result = "温馨提示"
            let alertController = UIAlertController(title: result, message: "确认退出登录嘛？", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)

            alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (UIAlertAction) in
                
                BmobUser.logout()
                let vc = loginViewController()
                vc.title = "登录"
                self.navigationController?.pushViewController(vc, animated: false)
                
            }))
            alertController.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
                
            }
        
        case 888:do{
            
            
            let user = BmobUser.getCurrent()
            
            if user == nil {
                
                let vc = loginViewController()
                vc.title = "登录"
                self.navigationController?.pushViewController(vc, animated: false)
                
            }else{
                
                let vc = userInfoViewController()
                vc.title = "编辑资料"
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
            
        }
        
        case 999:do {//开通会员
            
            let vc = vipViewController()
            vc.title = "开通会员"
            
            self.navigationController?.pushViewController(vc, animated: false)
                
            }
            
        default:
            break
            
        }
        
    }
    
   

}



