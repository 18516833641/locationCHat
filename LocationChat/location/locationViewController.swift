
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
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    
    
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
    
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            userPhone = user?.mobilePhoneNumber ?? ""
            nickName = user?.object(forKey: "nickName") as! String
            
            if vip as! String == "1" {//已经开通vip
                
                //跳转我的轨迹查询自己的轨迹
                let vc = myLoactionViewController()
                
                self.navigationController?.pushViewController(vc, animated: false)
                
            }else if vip as! String == "0"{//未开通vip
            
                let alertView = SmileAlert(title: "赶快去解锁吧", message: "位置变动提醒.\n实时定位和轨迹移动提醒.\n一键报警.", cancelButtonTitle: "取 消", sureButtonTitle: "确 定")
                        alertView.show()
                        //获取点击事件
                        alertView.clickIndexClosure { (index) in
                            print("点击了第" + "\(index)" + "个按钮")
                            
                            if(index == 2){
                                let vc = vipViewController()
                                vc.title = "解锁特权"
                                self.navigationController?.pushViewController(vc, animated: false)
                                alertView.dismiss()
                            }
                            
                        }
                
               
            }
        }else{
            //对象为空时，可打开用户注册界面
            
        }
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

    func addlocation() {
    
        let gamescore:BmobObject = BmobObject(className: "Locat" + userPhone)
        
        gamescore.setObject(latitude, forKey: "latitude")

        gamescore.setObject(longitude, forKey: "longitude")

        gamescore.setObject(myLocation.text, forKey: "location")

        gamescore.setObject(myTime.text, forKey: "lastTime")

        gamescore.saveInBackground { [weak gamescore] (isSuccessful, error) in
            if error != nil{
                //发生错误后的动作
//                SVProgressHUD.showError(withStatus: "添加好友失败，好友已存在")
//                SVProgressHUD.dismiss(withDelay: 0.75)
            }else{
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                //创建对象成功，打印对象值
                if let game = gamescore {
                    print("save success \(game)")
//                    SVProgressHUD.show(withStatus: "添加好友成功")
//                    SVProgressHUD.dismiss(withDelay: 0.75)
//                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
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
        
        latitude = location.coordinate.latitude
        
        longitude = location.coordinate.longitude
        
        if let reGeocode = reGeocode {
            NSLog("reGeocode:%@", reGeocode)
            myLocation.text = reGeocode.formattedAddress
            myTime.text = currentTime()
            
            
            let user = BmobUser.current()
            
            if user != nil {
                //跟新用户地址
                updateLocation()
                //进行操作
                let vip = user?.object(forKey: "vip")
                userPhone = user?.mobilePhoneNumber ?? ""
                nickName = user?.object(forKey: "nickName") as! String
                if vip as! String == "1" {//已经开通vip
                    
                    //开通会员开始开启轨迹
                    addlocation()
                    
                }else if vip as! String == "0"{//未开通vip
                
                    
                    
                   
                }
            }else{
                //对象为空时，可打开用户注册界面
                
            }
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
            self.title = "关于我们"
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



