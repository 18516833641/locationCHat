//
//  cancelViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/18.
//

import UIKit

class cancelViewController: AnalyticsViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tijiaoAction(_ sender: Any) {
        
        let user = BmobUser.current()
        
        if user != nil {
            
            let cancel = user?.object(forKey: "cancel")
            
            if cancel as! String == "1" {
                
                SVProgressHUD.show(withStatus: "您的注销申请已提交，请不要重复提交")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            
            let alertView = SmileAlert(title: "注销账户", message: "注销账户后，您将清楚您的所有数据且不能继续使用APP，请确认是否注销.", cancelButtonTitle: "我在想想", sureButtonTitle: "去意已决")
                alertView.show()
                //获取点击事件
                alertView.clickIndexClosure { (index) in
    //                print("点击了第" + "\(index)" + "个按钮")
                    
                    if(index == 2){
                        
                        alertView.dismiss()
                        
                        
                        let user = BmobUser.current()
                        user!.setObject("1", forKey: "cancel")
                        user!.updateInBackground { (isSuccessful, error) in

                            if(isSuccessful){
                                SVProgressHUD.show(withStatus: "您的注销申请已提交，请2个工作日后关注注销结果")
                                SVProgressHUD.dismiss(withDelay: 1)
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                SVProgressHUD.show(withStatus: "用户申请注销失败")
                                SVProgressHUD.dismiss(withDelay: 1)
                            }
                            
                        }
                        
                    }
                    
            }
            
        }else{
            
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
            
            
        }

    }

}
