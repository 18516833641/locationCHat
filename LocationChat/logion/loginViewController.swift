//
//  loginViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit
import AVFoundation


class loginViewController: AnalyticsViewController {

    @IBOutlet weak var loginUser: UITextField!
    
    @IBOutlet weak var loginPass: UITextField!
    
    @IBOutlet weak var loginCode: UIButton!
    
    @IBOutlet var setUI: UIView!
    
    var player:AVPlayer? = nil
    
    var timer:Timer!
    var timetip:Int = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginUser.attributedPlaceholder = NSAttributedString.init(string:"请输入您的手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        
        loginPass.attributedPlaceholder = NSAttributedString.init(string:"请输入验证码", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        
        SetUI()
    }

    //MARK:登录按钮
    @IBAction func loginAction(_ sender: Any) {
        
        BmobUser.logout()
        
        guard let username = loginUser.text,username.count > 1 else {
            SVProgressHUD.showError(withStatus: "请输入注册用户手机号码")
            SVProgressHUD.dismiss(withDelay: 0.75)
            return
        }

        guard let code = loginPass.text,code.count > 1 else {
            SVProgressHUD.showError(withStatus: "请输入手机验证码")
            SVProgressHUD.dismiss(withDelay: 0.75)
            return
        }
        
        let query = BmobUser.query()
        query?.whereKey("username", equalTo: loginUser.text)
        query?.findObjectsInBackground { (array, error) in

            if error != nil{//走登录

                BmobUser.loginInbackground(withMobilePhoneNumber: self.loginUser.text, andSMSCode: self.loginPass.text) { (user, error) in
                        if user != nil{
                            SVProgressHUD.show(withStatus: "登录成功")
                            SVProgressHUD.dismiss(withDelay: 0.75)
                            self.navigationController!.popViewController(animated: true)
                        }else{
                            
                            print("=======\(error)")
                            SVProgressHUD.showError(withStatus: "登录失败，请检查手机号、验证码")
                            SVProgressHUD.dismiss(withDelay: 0.75)
                           
                        }
                    }
                
            }else{//未查询到用户 走注册

    
                let user = BmobUser()
                user.mobilePhoneNumber = self.loginUser.text//手机号
                user.setObject(0, forKey: "vip")//vip
                user.setObject("0", forKey: "cancel")//是否注销账户
//                user.setObject("", forKey: "nickName")//昵称
                user.setObject("", forKey: "vipTime")//开通会员时间
                user.setObject("", forKey: "vipMoney")//开通会员钱
                    
                user.signUpOrLoginInbackground(withSMSCode: self.loginPass.text) { (isSuccessful, error) in
                    if error == nil{

                        print("\(user)")

                        SVProgressHUD.showInfo(withStatus: "登录成功")
                        SVProgressHUD.dismiss(withDelay: 0.75)
                        self.navigationController!.popViewController(animated: true)

                    }else{
                        print("=====\(String(describing: error))")
                    }
                }
                
                }
        }
    }
    
    //验证码
    @IBAction func codeAction(_ sender: Any) {
        
        guard let username = loginUser.text,username.count > 1 else {
            SVProgressHUD.showError(withStatus: "请输入注册用户手机号码")
            SVProgressHUD.dismiss(withDelay: 0.75)
            return
        }
        /**
         *  请求验证码
         *
         *  @param number      手机号
         *  @param templateStr 模板名
         *  @param block       请求回调
         */
        BmobSMS.requestCodeInBackground(withPhoneNumber: loginUser.text, andTemplate: "手机定位") { (magid, error) in
            if((error) != nil){
                
                print("masgid=======\(magid)")
            }else{
                print("error ===== \(String(describing: error))")
            }
        }
        
        loginCode.isUserInteractionEnabled = false
        timetip = 60
        //启动定时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.timetip -= 1
            if(self.timetip == 0){
                timer.invalidate()

                self.loginCode.setTitle("发送验证码", for: .normal)
                self.loginCode.isUserInteractionEnabled = true
            }else{
                self.loginCode.setTitle("\(self.timetip)s后", for: .normal)
            }
        }
        timer.fire()
        
    }
    func SetUI() {
        
        guard let  filePath =  Bundle.main.path( forResource: "BridgeLoop-640p" , ofType:  "mp4" ) else {
            
            return
            
        }
        
        let videoURL = URL(fileURLWithPath: filePath)
        
        //定义一个视频播放器，通过本地文件路径初始化
        player = AVPlayer(url: videoURL)

        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        player?.actionAtItemEnd = .none

        player!.play()

        NotificationCenter.default.addObserver(self, selector: #selector(playItemDidPlayToEndTimeNottidication(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)


        self.view.bringSubviewToFront(setUI)

        
    }
    
    @objc func playItemDidPlayToEndTimeNottidication(notification:Notification) {
        
        if let playerItem = notification.object as? AVPlayerItem {
            
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }

    }
    
    //用户协议
    @IBAction func yhxyAction(_ sender: Any) {
        
        let vc = xieyiViewController()
        vc.title = "用户协议"
     
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //隐私政策
    @IBAction func yszcAction(_ sender: Any) {
        
        let vc = yinsiViewController()
        vc.title = "隐私政策"
    
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
