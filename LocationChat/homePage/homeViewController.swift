//
//  homeViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit

class homeViewController: AnalyticsViewController {

    @IBOutlet weak var userIamge: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArr:[String] = []
    var addressArr:[String] = []
    var headerImage:[String] = []
    var objectID:[String] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关心的人"

        

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "friendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendTableViewCell")
        
//        self.navigationItem.leftBarButtonItem = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nickName.font = UIFont(name: "Helvetica-Bold", size: 15)
        let user = BmobUser.current()
        if user != nil {
            
//            nickName.text = user?.object(forKey: "nickName") as? String
            time.text = user?.object(forKey: "LocationTime") as? String
            address.text = user?.object(forKey: "location") as? String
            quertLocation()
        }else{
            time.text = UserDefaults.string(forKey: .time)
            address.text = UserDefaults.string(forKey: .address)
            
        }
        if let savedImage = UIImage(contentsOfFile: UserDefaults.string(forKey: .headerImage) ?? "") {
            
            self.userIamge.image = savedImage
            
        } else {
            
            print("文件不存在")
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
//        locationManager.stopUpdatingLocation()

    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        
        let user = BmobUser.current()
        if user != nil {
            
            let vc = addFriendViewController()
            vc.title = "添加关心的人"
            self.navigationController?.pushViewController(vc, animated: false)
            
        }else{
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
        
    }
    
    @IBAction func baojingAction(_ sender: Any) {
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            
            if vip as! Int == 0 {//未开通vip
                
                pushVipControllent()
                
            }else {//已开通vip
                
                addSMS()
                
            }
        }else{
            
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
           
        }
        
        
        
    }
    
    func addSMS() {
        
        
        let user = BmobUser.current()
        let userPhone = user?.mobilePhoneNumber ?? ""
        
        let alert = UIAlertController.init(title: "紧急求救", message: nil, preferredStyle: .alert)
                
        //添加textField
        alert.addTextField { (textField) in
            //这里对textField进行设置
            textField.placeholder = "输入手机号发送求救短信"
            textField.keyboardType = .numberPad
        
        }

        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            //这里获取textField的内容进行操作
            let phone = (alert.textFields?.first)!.text!
            print("输入的内容:\(phone)")
            
            if !self.isTelNumber(num: phone ) {
                    
                SVProgressHUD.showError(withStatus: "请输入正确的手机号")
                SVProgressHUD.dismiss(withDelay: 0.75)
                return
            }
            
            if phone == userPhone {
                SVProgressHUD.showError(withStatus: "本机用户不可发送")
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
            BmobSMS.requestCodeInBackground(withPhoneNumber: phone, andTemplate: "sos") { (magid, error) in
                if((error) != nil){
                    
                    print("masgid=======\(magid)")
                    
                    SVProgressHUD.showInfo(withStatus: "报警短信已发送")
                    SVProgressHUD.dismiss()
                }else{
                    print("error ===== \(String(describing: error))")
                }
            }

        }))

        present(alert, animated: true, completion: nil)
        
        
    }
    
    func quertLocation() {
        
        self.nameArr.removeAll()
        self.addressArr.removeAll()
        self.objectID.removeAll()
        
        let user = BmobUser.current()
            
        let query:BmobQuery = BmobQuery(className: "friend" + user!.mobilePhoneNumber)
            query.findObjectsInBackground { (array, error) in
                for i in 0..<array!.count{
                    let obj = array?[i] as! BmobObject
                    
                    self.nameArr.append(obj.object(forKey: "userPhone") as? String ?? "")
                    self.addressArr.append(obj.object(forKey: "location") as? String ?? "")
                    self.objectID.append(obj.object(forKey: "objectId") as? String ?? "")
//                    print("-------- \(self.nameArr + self.addressArr))")
           
               }
                self.tableView.reloadData()
           }

                
     
        
        
    
}
}

extension homeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell:friendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell") as? friendTableViewCell else {
            let cells = friendTableViewCell(style: .default, reuseIdentifier: "friendTableViewCell")
            cells.backgroundColor = .groupTableViewBackground
            return cells
        }
        
//        let nameData = nameArr[indexPath.row]
//
        cell.userPhone.text = nameArr[indexPath.row]
        cell.userAddress.text = addressArr[indexPath.row]
//        cell.u.text = listData.tile
//
//        cell.listImage.sd_setImage(with: URL(string:BERKKURL.Url_SeverImage + listData.thmb!), placeholderImage: UIImage(named: "zwsj"), options: .refreshCached, completed: nil)
      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellData = dataSource[indexPath.row]
//        let vc = listDetailViewController()
//        vc.title = "工程案例详情"
//        vc.url = BERKKURL.URL_EngineeringList + "/" + cellData.id!
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//        
    }
    
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true;
    }
        
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let user = BmobUser.current()
            
            let gamescore:BmobObject = BmobObject(outDataWithClassName: "friend" + user!.mobilePhoneNumber, objectId: objectID[indexPath.row])
            gamescore.deleteInBackground { (isSuccessful, error) in
                    if (isSuccessful) {
                        //删除成功后的动作
                        print ("-----success");
                        self.quertLocation()
                        
                        tableView.reloadData()
                    }else{
                        print("delete error \(String(describing: error?.localizedDescription))")
                    }
                }
        }

   }
}
