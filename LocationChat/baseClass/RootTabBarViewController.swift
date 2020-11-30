//
//  RootTabBarViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit

class RootTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabBar()
        modifyTabbar()
    }
    
    // 添加子控制器添加图片
    private func addChildVCWithImg(childVC: UIViewController, childTitle: String , imageName: String, selectedImageName:String ,index: Int)
    {
        //0.新建一个子控制器对象
        let navigation = RootNavigationViewController(rootViewController: childVC)
        //1.设置子控制器标题
        childVC.title = childTitle
        //2.设置子控制器排序
        childVC.tabBarItem.tag = index
        //3.设置子控制器未选中状态下的图片
        childVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    
    
        //4.x设置子控制器选中状态下的图片
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
//        childVC.tabBarItem.selectedImage?.size = CGSize(width: 50, height: 50)
        //5.将子控制器加入到tabbar控制器中
        self.addChild(navigation)
        //        self.configurationAppTabBarAndNavigationBar()
            }
        
        /// 修改原生tabbar
    func modifyTabbar() {
            //设置选中字体颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(red: 19/255.0, green: 157/255.0, blue: 196/255.0, alpha: 1)], for: UIControl.State.selected)
//    //        //设置未选中状态下字体颜色
//            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(red: 19/255.0, green: 134/255.0, blue: 139/255.0, alpha: 1)], for: UIControl.State.normal)
            
            
            //因为tabbar有默认的渲染色，所以要先去掉，否则颜色并不是想要的颜色
            UITabBar.appearance().isTranslucent = false
            //之后再设置tabbar的背景色
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0.1254901961, green: 0.1490196078, blue: 0.1882352941, alpha: 1)
            self.tabBar.insertSubview(Utils.drawTabBarImageView(), at: 0)
//        self.tabBar.selectedItem = 1
            
            //下面这个方法可以取消掉tabbar上的灰色线
            if #available(iOS 13, *) {
              let appearance = self.tabBar.standardAppearance.copy()
              appearance.backgroundImage = UIImage()
              appearance.shadowImage = UIImage()
              appearance.shadowColor = .clear
              self.tabBar.standardAppearance = appearance
            } else {
              self.tabBar.shadowImage = UIImage()
              self.tabBar.backgroundImage = UIImage()
            }
        }
    

    
    func initTabBar() {
        
        self.tabBar.barTintColor = .white
        let homevc = homeViewController()
        homevc.tabBarItem.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.addChildVCWithImg(childVC: homevc,
                            childTitle: "添加好友",
                             imageName: "tabbar_homePage",
                     selectedImageName: "tabbar_homePageSelect",
                                 index: 0)
        
        let locationvc = locationViewController()
        locationvc.tabBarItem.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.addChildVCWithImg(childVC: locationvc,
                            childTitle: "",
                             imageName: "tabbar_location",
                     selectedImageName: "tabbar_locationSelsect",
                                 index: 1)
        
        let searchvc = searchViewController()
        searchvc.tabBarItem.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.addChildVCWithImg(childVC: searchvc,
                            childTitle: "搜索",
                             imageName: "tabbar_search",
                     selectedImageName: "tabbar_searchSelect",
                                 index: 2)
    }
        
        
        override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//            print("ssss\(item.tag)")
            
            switch item.tag {
            case 1:
                do {
    //                NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue:"isTest"), object: nil)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAction"), object: nil, userInfo: nil)
                        
                }
            default:
                break
            }
                
        }

}
