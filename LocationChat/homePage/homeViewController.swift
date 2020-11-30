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
        
        //查找GameScore表
        
        let user = BmobUser.current()

        let userPhone = user?.mobilePhoneNumber ?? ""

       
        let query:BmobQuery = BmobQuery(className: "location")
        query.whereKey("userPhone", notEqualTo: userPhone)
        

        query.findObjectsInBackground { (array, error) in
            
            
        if error != nil {
            //进行错误处理
            print("======\(error)")
        }else{
            for i in 0..<array!.count{
                let obj = array![i] as! BmobObject
                let name = obj.object(forKey: "userPhone")
                //打印名字
                print("userPhone----------- \(name)")
            }
        }
            
            
        }
        
//        query.getObjectInBackground(withId: "5b3c5d4b881") { (obj, error) in
//                if error != nil {
//                    //进行错误处理
//                    print("======\(error)")
//                }else{
//                    if obj != nil{
//                        //得到playerName和cheatMode
//
//
//                        let playerName = obj?.object(forKey: "location") as? String
//                        let cheatMode  = obj?.object(forKey: "cheatMode") as? Bool
//                        print("playerName \(playerName),cheatMode \(cheatMode)")
//                        //打印objectId,createdAt,updatedAt
//                        print("objectid   \(obj?.objectId)")
//                        print("createdAt  \(obj?.createdAt)")
//                        print("updatedAt  \(obj?.updatedAt)")
//                    }
//                }
//            }
        
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
   
}
