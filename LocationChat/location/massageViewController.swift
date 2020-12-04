//
//  massageViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/10.
//

import UIKit

class massageViewController: AnalyticsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var vipTime = ""
    var titile = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "系统消息"
        
        tableView.register(UINib(nibName: "massageTableViewCell", bundle: nil), forCellReuseIdentifier: "massageTableViewCell")
       
        // Do any additional setup after loading the view.
        
        let user = BmobUser.current()
        
        if user != nil {
            
            
            let user = BmobUser.current()
            
            vipTime = user?.object(forKey: "vipTime") as! String
            titile = user?.mobilePhoneNumber ?? ""
            
        }else{
            
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
            
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

}


extension massageViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if vipTime.isEmpty {
            return 0
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell:massageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "massageTableViewCell") as? massageTableViewCell else {
            let cells = massageTableViewCell(style: .default, reuseIdentifier: "massageTableViewCell")
//            cells.backgroundColor = .groupTableViewBackground
            return cells
        }
        cell.time.text = vipTime
        cell.title.text = "用户您好，您与" + vipTime + "开通会员，到期自动续费服务，如若取消，请与会员到期前一天进行取消订阅"

      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("点击了第 : \(indexPath.row) 个 cell")
//
//        self.delegate?.pushToNewViewController(index: indexPath.row)
    }
   
}
