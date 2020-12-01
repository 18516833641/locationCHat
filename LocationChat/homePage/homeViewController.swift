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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关心的人"

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "friendTableViewCell", bundle: nil), forCellReuseIdentifier: "friendTableViewCell")
        
//        self.navigationItem.leftBarButtonItem = nil
        
        quertLocation()
    }
    
    
    
    @IBAction func addAction(_ sender: Any) {
        let vc = addFriendViewController()
        vc.title = "添加关心的人"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func baojingAction(_ sender: Any) {
        
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
    
    func quertLocation() {
        
        let user = BmobUser.current()
        if user != nil {
            
        let query:BmobQuery = BmobQuery(className: "friend" + user!.mobilePhoneNumber)
            query.findObjectsInBackground { (array, error) in
                for i in 0..<array!.count{
                    let obj = array?[i] as! BmobObject
                    
//                    let playerName = obj.object(forKey: "playerName") as? String
           
                   print("playerName \(obj)")
           
               }
           }

                
        }else{
            //对象为空时，可打开用户注册界面
            BmobUser.logout()
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
        
    
}
}

extension homeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell:friendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "friendTableViewCell") as? friendTableViewCell else {
            let cells = friendTableViewCell(style: .default, reuseIdentifier: "friendTableViewCell")
            cells.backgroundColor = .groupTableViewBackground
            return cells
        }
        
//        let listData = dataSource[indexPath.row]
//
//        cell.titleLabel.text = listData.tile
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
              print("-------")
        }

   }
}
