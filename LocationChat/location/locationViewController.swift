
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
    
    var userPhone = ""
    var nickName = ""
    
    
    
    
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "手机定位"

        //定位开启
        loactionAction()
    
        setLeftNavigationButton()
        
        setRightNavigationButton()
        
        let vc:leftRootViewController = self.mm_drawerController.leftDrawerViewController as! leftRootViewController

        vc.delegate = self
        
        self.view.bringSubviewToFront(topView)
        
        // 启用计时器，控制每秒执行一次tickDown方法
//        timer = Timer.scheduledTimer(timeInterval: 10,target:self,selector:#selector(tickDown),userInfo:nil,repeats:true)
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            userPhone = user?.mobilePhoneNumber ?? ""
            nickName = user?.object(forKey: "nickName") as! String
            
            if vip as! String == "1" {//已经开通vip
                
                
            }else if vip as! String == "0"{//未开通vip
            
                
               
            }
        }else{
            //对象为空时，可打开用户注册界面
            
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()

    }

    func updateLocation(){
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            user?.setObject(myLocation.text, forKey: "location")
            user?.setObject(myTime.text, forKey: "LocationTime")
            user?.updateInBackground { (isSuccessful, error) in

                if(isSuccessful){
                    print("=====")
                }else{
                    print("-----")
                }
            }
        }else{
            //对象为空时，可打开用户注册界面
        }
        
      
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

//        startTrackServer()
        let vc = guijiViewController()
        self.navigationController?.pushViewController(vc, animated: false)
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

    //MARK:获取当前时间
    func currentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm"// 自定义时间格式
        // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }


}

extension locationViewController:MAMapViewDelegate,AMapLocationManagerDelegate{
    
    
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

        print("-----坐标:\(location.coordinate)")
        if let reGeocode = reGeocode {
            NSLog("reGeocode:%@", reGeocode)
            myLocation.text = reGeocode.formattedAddress
            myTime.text = currentTime()
            updateLocation()
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



