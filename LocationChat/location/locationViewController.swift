
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
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myTime: UILabel!
    @IBOutlet weak var myLocation: UILabel!
    //    var clousre : MKPositioningClosure?
    
    @IBOutlet weak var user_header: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    let locationManager = AMapLocationManager()
    
    var userPhone = ""
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    
    
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "手机定位"
        myName.font = UIFont(name: "Helvetica-Bold", size: 15)
        //定位开启
        loactionAction()
    
        setLeftNavigationButton()
        
        setRightNavigationButton()
        
        let vc:leftRootViewController = self.mm_drawerController.leftDrawerViewController as! leftRootViewController

        vc.delegate = self
        
        self.view.bringSubviewToFront(topView)
        self.view.bringSubviewToFront(searchView)
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        if let savedImage = UIImage(contentsOfFile: UserDefaults.string(forKey: .headerImage) ?? "") {
            
            self.user_header.image = savedImage
            
        } else {
            
            print("文件不存在")
            
        }
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
    //MARK:搜索
    @IBAction func searchButAction(_ sender: Any) {
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            userPhone = user?.mobilePhoneNumber ?? ""
            
            if vip as! Int == 0 {//未开通vip
                
                pushVipControllent()
                
            }else {//已开通
                
                //添加好友
                addFriend()
            
            }
        }else{
            //对象为空时，可打开用户注册界面
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    //MARK:我的轨迹
    @IBAction func myLoactionAction(_ sender: Any) {
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            userPhone = user?.mobilePhoneNumber ?? ""

            if vip as! Int == 0 {//已经开通vip
                
                pushVipControllent()
                
            }else{//未开通vip
            
                //跳转我的轨迹查询自己的轨迹
                let vc = myLoactionViewController()
                
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
        }else{
            //对象为空时，可打开用户注册界面
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    //MARK:定位
    func loactionAction() {
        
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.zoomLevel = 16
        mapView.maxZoomLevel = 17
        mapView.minZoomLevel = 11
//        mapView.
        mapView.userTrackingMode = .follow
        mapView.isShowsUserLocation = true
        self.view.addSubview(mapView)
        
        
        
        locationManager.delegate = self
        locationManager.distanceFilter = 100//设置定位最小更新距离方法如下，单位米
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.locationTimeout = 10
        locationManager.reGeocodeTimeout = 10
//        locationManager.enablePulseAnnimation = true
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
    
    func addFriend() {
        
        let user = BmobUser.current()
        let userPhone = user?.mobilePhoneNumber ?? ""
        
        let query = BmobUser.query()
        query?.whereKey("username", equalTo: textField.text)
        query?.findObjectsInBackground { (array, error) in

            if error != nil{
//                    print("========\(error)")
            }else{

                if array?.count == 0 {

                    SVProgressHUD.showError(withStatus: "输入的用户不存在")
                    SVProgressHUD.dismiss(withDelay: 0.75)
                    return
                }

                for obj in array! as Array {
                    
                    let user  = obj as! BmobUser
                    
                    let gamescore:BmobObject = BmobObject(className: "friend" + userPhone)
                    
                    gamescore.setObject("friend", forKey: "between")
                    
                    gamescore.setObject(user.object(forKey: "location"), forKey: "location")
                 
                    gamescore.setObject(user.mobilePhoneNumber, forKey: "userPhone")
                    
                    gamescore.saveInBackground { [weak gamescore] (isSuccessful, error) in
                        
                        if error != nil{
                            //发生错误后的动作
                            SVProgressHUD.showError(withStatus: "添加好友失败，好友已存在")
                            SVProgressHUD.dismiss(withDelay: 0.75)
                        }else{
                            //创建成功后会返回objectId，updatedAt，createdAt等信息
                            //创建对象成功，打印对象值
                            if let game = gamescore {
                                print("save success \(game)")
                                SVProgressHUD.show(withStatus: "添加好友成功")
                                SVProgressHUD.dismiss(withDelay: 0.75)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        self.textField.text = ""
                        let vc = homeViewController()
                        self.navigationController?.pushViewController(vc, animated: false)
                    }




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
            UserDefaults.set(value: myLocation.text ?? "", forKey: UserDefaults.LoginInfo.address)
            UserDefaults.set(value: myTime.text ?? "", forKey: UserDefaults.LoginInfo.time)
            
            let user = BmobUser.current()
            
            if user != nil {
                //跟新用户地址
                updateLocation()
                //进行操作
                let vip = user?.object(forKey: "vip")
                userPhone = user?.mobilePhoneNumber ?? ""
                if vip as! Int == 0 {//未开通vip
                    
                }else{//已经开通vip
                
                    //开通会员开始开启轨迹
                    addlocation()
                   
                }
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
            
            
            let user = BmobUser.current()
            
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



