//
//  vipViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
//

import UIKit
import StoreKit

class vipViewController: AnalyticsViewController {

    @IBOutlet weak var vipLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var conllectionView: UICollectionView!
    
    @IBOutlet weak var uiview: UIView!
    
    //layout上下距离
    let LAYOUT_LEFTORRIGHT_WIDTH : CGFloat = (UIScreen.main.bounds.width-40)/5 + 20
    let CELL_WIDTH : CGFloat = (UIScreen.main.bounds.width-40)*3/4
    let CELL_HEIGHT : CGFloat = UIScreen.main.bounds.height*0.2
    
    var observer : StoreObserver? //内购监听器
    var prouctNmaeArray = [String]() //
    var productIdArray = [String]() //存放内购产品
    var putchaseArray = [SKProduct]() //存放内购产品
    var selectedProduct : SKProduct? //选中的产品
    
    var select = 1 //选择的商品编号
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        payButton.isHidden = true
        
        let user = BmobUser.current()
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            
            if vip as! Int == 0 {//未开通vip
                
                vipLabel.text = "未开通vip"
               
            }else{//已开通vip
                
                vipLabel.text = "已开通vip"
                
               
            }
        }else{
           
        }
        
        setUICollectionView()
        
        paomadengAction()
        
        
        SVProgressHUD.show(withStatus: "产品加载中...")
        
        
        //内购
        self.observer = StoreObserver.shareStoreObserver()
        self.observer?.create()
        
        //内购数据
        self.prouctNmaeArray = ["68","168","268"]
        self.productIdArray = ["2020120230","2020120290","20201202365"] //产品id
        //获取所有的商品
        self.observer?.requestProductDataWithIds(productIds: self.productIdArray)
        
        //内购之后的状态--产品加载完成
        NotificationCenter.default.addObserver(self, selector: #selector(productsLoaded(nofi:)), name: NSNotification.Name(rawValue: ProductsLoadedSucessNotification), object: nil)
        //内购之后的状态--产品交易完成
        NotificationCenter.default.addObserver(self, selector: #selector(productPurchased(nofi:)), name: NSNotification.Name(rawValue: "ProductPurchased"), object: nil)
        //内购之后的状态--产品交易失败
        NotificationCenter.default.addObserver(self, selector: #selector(productPurchaseFailed(nofi:)), name: NSNotification.Name(rawValue: "ProductPurchaseFailed"), object: nil)
        //内购之后的状态--产品交易恢复
        NotificationCenter.default.addObserver(self, selector: #selector(productRestored(nofi:)), name: NSNotification.Name(rawValue: "ProductRestore"), object: nil)
        
    }
    //销毁
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.observer?.destroy()
    }

    @IBAction func payAction(_ sender: Any) {
        
        
        let user = BmobUser.current()
        
//        let address = user?.object(forKey: "location") as? String
        
        if user != nil {
            //进行操作
            let vip = user?.object(forKey: "vip")
            
            if vip as! Int == 0 {//未开通vip
                
                SVProgressHUD.showInfo(withStatus: "购买过程与Apple商城链接有关，请耐心等待，避免购买错误")
                SVProgressHUD.dismiss(withDelay: 1.75)
                DispatchQueue.main.asyncAfter(deadline: .now()+1.8) {
        //            SVProgressHUD.show()
                }
                
                payButton.isHidden = true
                let tagIndex = (sender as AnyObject).tag + select
                
               self.observer?.buyProduct(product: self.putchaseArray[tagIndex])
                
                
            }else{//已开通vip
                
                
                
               
            }
        }else{
            //对象为空时，可打开用户注册界面
            let vc = loginViewController()
            vc.title = "登录"
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    //MARK:设置跑马灯
    func paomadengAction() {
        
        let dataArray = ["156****4679用户05分钟前充值季卡",
                         "185****7771用户10分钟前充值月卡",
                         "177****6051用户15分钟前充值年卡",
                         "135****7890用户20分钟前充值月卡",
                         "135****7890用户25分钟前充值月卡",
                         "135****7890用户30分钟前充值年卡"
        ]
        var items: [GCMarqueeModel] = []
        
        for str in dataArray {
            let model = GCMarqueeModel(title: str)
            items.append(model)
        }
        
        let view = GCMarqueeView(frame: CGRect(x: uiview.bounds.minX, y: uiview.bounds.minY, width: uiview.frame.width, height: uiview.frame.height), type: .rtl);
        view.backgroundColor = .clear
        view.items = items
        self.view.addSubview(view)
        
        
    }
    
    //MARK:设置collectionView
    func setUICollectionView() {
        
        conllectionView.register(UINib(nibName: "vipCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "vipcell")
        
        let layout = CDFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: LAYOUT_LEFTORRIGHT_WIDTH, bottom: 0, right: LAYOUT_LEFTORRIGHT_WIDTH)
        layout.itemSize = CGSize(width: CELL_WIDTH, height: CELL_HEIGHT)
        
        conllectionView.collectionViewLayout = layout
        conllectionView.showsHorizontalScrollIndicator = false
        conllectionView.reloadData()
    }
    
    
    //实现通知监听方法---产品加载完成
     @objc func productsLoaded(nofi : Notification){
        print("产品加载完成")
        
        payButton.isHidden = false
        SVProgressHUD.dismiss()
         self.putchaseArray = nofi.object  as! [SKProduct]
     }
     
     //实现通知监听方法---支付成功 并且第一次验证成功
     @objc func productPurchased(nofi : Notification) {
        payButton.isHidden = false
        SVProgressHUD.dismiss()
        //和后台服务器交接
        print("---支付成功\(nofi)")
        
        
        
        let user = BmobUser.current()
        user?.setObject(select + 1, forKey: "vip")
        user?.setObject(currentTime(),forKey:"vipTime")
        
        if select == 0 {
            user?.setObject("68",forKey:"vipMoney")
        }else if(select == 1){
            user?.setObject("168",forKey:"vipMoney")
        }else if(select == 2){
            user?.setObject("268",forKey:"vipMoney")
        }
        user?.updateInBackground { (isSuccessful, error) in

            if(isSuccessful){

                print("恭喜您开通会员")

            }else{
                print("====\(error)")
            }

        }
        
     }
     
     //实现通知监听方法---- 失败
     @objc func  productFail(nofi : Notification) {
         print("交易失败\(nofi)")
        SVProgressHUD.dismiss()
        payButton.isHidden = false
     }
    
     //实现通知监听方法---- 重新购买
     @objc func  productRestored(nofi : Notification) {
        SVProgressHUD.dismiss()
        payButton.isHidden = false
     }
     
     //实现通知监听方法---- 失败
     @objc func  productPurchaseFailed(nofi : Notification) {
        SVProgressHUD.dismiss()
        payButton.isHidden = false
        print("交易失败-----")
         
        let  code = nofi.userInfo!["code"] as! String
        
        let alertController = UIAlertController(title: "温馨提示",message: code,preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
        })
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
         
     }

}

extension vipViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    //UICollectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:vipCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "vipcell", for: indexPath) as? vipCollectionViewCell else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: "vipcell", for: indexPath)
        }
        
        let defaultSelectCell = IndexPath(row: 1, section: 0)
        conllectionView.selectItem(at: defaultSelectCell, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
        
        let dataMoney = ["¥ 68","¥ 168","¥ 268"]
        let dataTitle = ["月卡会员","季卡会员","年卡会员"]
        let vipImage = ["vip_v1","vip_v2","vip_v3"]
        
        
        cell.money.text = dataMoney[indexPath.row]
        cell.title.text = dataTitle[indexPath.row]
        cell.vipIcon.image = UIImage(named: vipImage[indexPath.row])
        
        print(cell.bounds.size.height)
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("点击图片\(indexPath.row)")
//        select = indexPath.row
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pInView = self.view.convert(self.conllectionView.center, to: self.conllectionView)
        let indexPathNow = self.conllectionView.indexPathForItem(at: pInView)!
        print("=------\(indexPathNow.row)")
        select = indexPathNow.row
    }
}
