//
//  feedbackViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
//

import UIKit

class feedbackViewController: AnalyticsViewController {

    @IBOutlet weak var textView: YHTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "意见反馈"
        
        textView.placeHolder = "输入您的建议或者意见！"
    }

    @IBAction func downAction(_ sender: Any) {
        
        guard let textView = textView.text,textView.count > 1 else {
            SVProgressHUD.showError(withStatus: "输入您的建议或者意见！")
            SVProgressHUD.dismiss(withDelay: 0.75)
            return
        }
        
        let user = BmobUser.current()
        
        let userPhone = user?.mobilePhoneNumber ?? ""

        
        let gamescore:BmobObject = BmobObject(className: "feedback")
        //score为1200
        gamescore.setObject(textView, forKey: "feedback")
        //设置playerName为小明
        gamescore.setObject(userPhone, forKey: "userPhone")
        
        gamescore.saveInBackground { [weak gamescore] (isSuccessful, error) in
            if error != nil{
                //发生错误后的动作
                print("error is \(String(describing: error?.localizedDescription))")
            }else{
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                //创建对象成功，打印对象值
                if let game = gamescore {
                    print("save success \(game)")
                    
                    SVProgressHUD.show(withStatus: "感谢您的反馈！")
                    SVProgressHUD.dismiss(withDelay: 0.75)
                }
            }
        }
        
    }
    
}
