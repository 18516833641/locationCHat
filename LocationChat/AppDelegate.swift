//
//  AppDelegate.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let LocationKey = "ba7d79172f1bc51016bff4f56ecb1083"
//    var manager:CLLocationManager?

    
    
    var mmDrawerController:MMDrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Bmob.register(withAppKey: "65f3fec523ee91137365028c38c05106")
        
        //高德地图
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = LocationKey
        
        // 创建左中右控制器
        let selfTabbar = locationViewController()
        let leftController = leftRootViewController(nibName: "leftRootViewController", bundle: nil)
//        selfTabbar.selectedIndex = 1
        //加入导航控制器 并设置重用标志
        let centerNav:RootNavigationViewController = RootNavigationViewController(rootViewController: selfTabbar)

        mmDrawerController = MMDrawerController.init(center: centerNav, leftDrawerViewController:leftController)

        mmDrawerController?.restorationIdentifier = "MMDrawerController"
        mmDrawerController?.showsShadow = false
        

        mmDrawerController?.maximumLeftDrawerWidth = leftDrawerWidth
        mmDrawerController?.setDrawerVisualStateBlock({ (drawerController, drawerSide, percentVisible) in
           
            //设置动画，这里是设置打开侧栏透明度从0到1
            

            
            //设置视觉差动画
            let block: MMDrawerControllerDrawerVisualStateBlock = MMDrawerVisualState.parallaxVisualStateBlock(withParallaxFactor: 2.0);
            block(drawerController, drawerSide, percentVisible)
        });
        //打开抽屉手势
        mmDrawerController?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningNavigationBar
        //关闭抽屉手势
        mmDrawerController?.closeDrawerGestureModeMask = .all
        self.window?.rootViewController = mmDrawerController
        
        return true
    }

    /**
     联网结果回调
     
     @param iError 联网结果错误码信息，0代表联网成功
     */
    func onGetNetworkState(_ iError: Int32) {
        if 0 == iError {
            NSLog("联网成功")
        } else {
            NSLog("联网失败：%d", iError)
        }
    }
    /**
     鉴权结果回调
     
     @param iError 鉴权结果错误码信息，0代表鉴权成功
     */
    func onGetPermissionState(_ iError: Int32) {
        if 0 == iError {
            NSLog("授权成功")
        } else {
            NSLog("授权失败：%d", iError)
        }
    }

}

