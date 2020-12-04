//
//  leftRootViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/2.
//

import UIKit

public protocol LeftViewControllerDelegate :class{
    /// 让 GAB_CenterViewController 遵守 去跳转
    func pushToNewViewController(index:Int)
}

class leftRootViewController: AnalyticsViewController {

    @IBOutlet weak var user_header: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var vipLevel: UIImageView!
    
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak  var delegate:LeftViewControllerDelegate?
    
    let nameArr = ["家人守护","意见反馈","位置权限","清除缓存","关于我们","注销账户","退出登录"]
    let imageArr = ["icon_shjr","icon_yjfk","icon_wzqx","icon_qchc","icon_gywm","icon_zxzh","icon_tcdl"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWidth.constant = leftDrawerWidth
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "leftTableViewCell", bundle: nil), forCellReuseIdentifier: "leftTableViewCell")
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = BmobUser.current()
        
        if user != nil {
            let niakname = user?.object(forKey: "nickName")
            let phone = user?.mobilePhoneNumber
            if niakname == nil {
                nickName.text = phone?.replacePhone()
            }else{
                nickName.text = niakname as? String
            }
            //进行操作
            let vip = user?.object(forKey: "vip")
            
            if vip as! Int == 0 {//未开通vip
                
                vipLevel.isHidden = true
           
               
            }else if vip as! Int == 1 {//已开通月卡会员
                
               
                vipLevel.isHidden = false
                vipLevel.image = UIImage.init(named: "Vip1")
                
               
            }else if vip as! Int == 2 {//已开通季卡会员
                
                vipLevel.isHidden = false
                vipLevel.image = UIImage.init(named: "Vip2")
                
                
            }else if vip as! Int == 3{//已开通年卡会员
                
                vipLevel.isHidden = false
                vipLevel.image = UIImage.init(named: "Vip3")
                
            }
        }else{
            
            nickName.text = "立即登录"
           
        }
        if let savedImage = UIImage(contentsOfFile: UserDefaults.string(forKey: .headerImage) ?? "") {
            
            self.user_header.image = savedImage
            
        } else {
            
            print("文件不存在")
            
        }
        
        
    }
    
    @IBAction func userAction(_ sender: Any) {
        
        self.delegate?.pushToNewViewController(index: 888)
    }
}

extension leftRootViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 9
//    }
    
    //组高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        headerView.backgroundColor = .white
        self.view.addSubview(headerView)
        
        let backImage = UIImageView.init(frame: CGRect(x: 20, y: 10, width: self.view.bounds.width - 40, height: 50))
        backImage.image  = UIImage.init(named: "search_membersIcon")
        headerView.addSubview(backImage)
        
        let titleLabel = UILabel.init(frame: CGRect(x: 40, y: 15, width: 100, height: 20))
        titleLabel.text = "专属特权"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 13)
        headerView.addSubview(titleLabel)
        // 26 171 168
        
        let titleLabel1 = UILabel.init(frame: CGRect(x: 40, y: titleLabel.frame.maxY, width: 100, height: 20))
        titleLabel1.text = "解锁后享用更多权利"
        titleLabel1.textColor = .white
        titleLabel1.font = UIFont(name: "Heiti TC", size: 10)
        headerView.addSubview(titleLabel1)

        let imageBut = UIButton.init(frame: CGRect(x: headerView.frame.width - 70, y: 20, width: 40, height: 18))
        imageBut.addTarget(self, action: #selector(buttonAction(select:)), for: .touchUpInside)
        imageBut.titleLabel?.font  = UIFont(name: "Heiti TC", size: 8)
        imageBut.setTitle("立即解锁", for: .normal)
        imageBut.backgroundColor = .white
        imageBut.layer.cornerRadius = 8
        imageBut.layer.borderColor = UIColor.white.cgColor
        imageBut.layer.borderWidth = 0.5
        imageBut.setTitleColor(UIColor.init(red: 26/255, green: 171/255, blue: 168/255, alpha: 1), for: .normal)
        headerView.addSubview(imageBut)
        
        return headerView
    }
    
    @objc func buttonAction(select:UIButton) {

        self.delegate?.pushToNewViewController(index: 999)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell:leftTableViewCell = tableView.dequeueReusableCell(withIdentifier: "leftTableViewCell") as? leftTableViewCell else {
            let cells = leftTableViewCell(style: .default, reuseIdentifier: "leftTableViewCell")
//            cells.backgroundColor = .groupTableViewBackground
            return cells
        }
        cell.icon.image = UIImage.init(named: imageArr[indexPath.item])
        cell.title.text = nameArr[indexPath.row]

      
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("点击了第 : \(indexPath.row) 个 cell")

        self.delegate?.pushToNewViewController(index: indexPath.row)
    }
   
}
