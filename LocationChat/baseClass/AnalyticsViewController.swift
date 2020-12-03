//
//  AnalyticsViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit

class AnalyticsViewController: UIViewController {
    
    let KScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    let KScreenHeight: CGFloat = UIScreen.main.bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .groupTableViewBackground
        
        let leftBarBtn = UIButton()
        leftBarBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftBarBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        leftBarBtn.setBackgroundImage(UIImage(named: "back"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(backToPrevious), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
    }

    //返回按钮点击响应
       @objc func backToPrevious(){
           self.navigationController!.popViewController(animated: true)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //在这里全局设置状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func pushVipControllent() {
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
    
    func isLogin() -> Bool {
        
        
        let user = BmobUser.current()
        
//        let address = user?.object(forKey: "location") as? String
        
        if user != nil {
            
            return true
            
        }else{
            
            BmobUser.logout()
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
            
            return false
        }
    }
    
    func isVip() -> Bool {
        let user = BmobUser.current()
        
        if user != nil {
        
            let vip = user?.object(forKey: "vip")
            
            if vip as! Int == 0 {//未开通vip
                
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
                return false
            }else {//已开通vip
                
                return true
            }
        }
        
        return false
    }
    
    //MARK:获取当前时间
    func currentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm"// 自定义时间格式
        // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }
    
    //MARK:判断手机号
    func isTelNumber(num:String)->Bool
    {
       let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
       let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
       let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
       let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
       let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
       let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
       let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
       let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
       if ((regextestmobile.evaluate(with: num) == true)
               || (regextestcm.evaluate(with: num)  == true)
               || (regextestct.evaluate(with: num) == true)
               || (regextestcu.evaluate(with: num) == true))
        {
            return true
        }
        else
       {
            return false
       }
   }
}
extension String {
 /// 替换手机号中间四位
    ///
    /// - Returns: 替换后的值
    func replacePhone() -> String {
        let start = self.index(self.startIndex,offsetBy: 3)
        let end = self.index(self.startIndex,offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start,upper: end))
        return self.replacingCharacters(in: range,with: "****")
    }
}



