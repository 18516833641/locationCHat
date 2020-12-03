//
//  addFriendViewController.swift
//  LocationChat
//
//  Created by mark on 2020/10/28.
//

import UIKit

class addFriendViewController: AnalyticsViewController {

    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.attributedPlaceholder = NSAttributedString.init(string:"输入想要查询的手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 0.05, green: 0.77, blue: 1, alpha: 1)])
        
        title1.textColor =  UIColor(red: 0.05, green: 0.77, blue: 1, alpha: 1)
        title2.textColor = UIColor(red: 0.05, green: 0.77, blue: 1, alpha: 1)

    }
    
    @IBAction func buttonAction(_ sender: Any) {
        
        
        let user = BmobUser.current()
        let userPhone = user?.mobilePhoneNumber ?? ""
        
        if !isTelNumber(num: textField.text ?? "") {
                
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            SVProgressHUD.dismiss(withDelay: 0.75)
            return
        }
        
        if textField.text == user?.mobilePhoneNumber {
            SVProgressHUD.showError(withStatus: "本机用户不可添加")
            SVProgressHUD.dismiss(withDelay: 0.75)
            return
        }
        
        if user != nil {
            
            let vip = user?.object(forKey: "vip")
            if vip as! Int == 0 {//未开通vip
                
                pushVipControllent()
                
            }else {//已开通vip
                
                
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
                            }




                            }
                        }
                    }
            
            }
            
            
//
                
        }else{
            
            
        }
        
        
       
    }
    
}

