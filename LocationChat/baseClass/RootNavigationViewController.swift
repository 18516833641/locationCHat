//
//  RootNavigationViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(red: 19/255.0, green: 134/255.0, blue: 139/255.0, alpha: 1)]
        
//        self.navigationBar.barTintColor = UIColor(red: 32/255.0, green: 38/255.0, blue: 48/255.0, alpha: 1)
//        self.navigationBar.barTintColor = UIColor(red: 32/255.0, green: 38/255.0, blue: 48/255.0, alpha: 1)
        
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        let appearance:UINavigationBar = UINavigationBar.appearance()
        appearance.barTintColor = navigationBarBackGroundColor()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17.0)]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let vc = self.topViewController
        return vc!.preferredStatusBarStyle
    }

}
