//
//  vipViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
//

import UIKit

class vipViewController: AnalyticsViewController {

    @IBOutlet weak var vipLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet weak var conllectionView: UICollectionView!
    
    @IBOutlet weak var uiview: UIView!
    
    //layout上下距离
    let LAYOUT_LEFTORRIGHT_WIDTH : CGFloat = (UIScreen.main.bounds.width-40)/5 + 20
    let CELL_WIDTH : CGFloat = (UIScreen.main.bounds.width-40)*3/4
    let CELL_HEIGHT : CGFloat = UIScreen.main.bounds.height*0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        vipMoney.font = UIFont(name: "Helvetica-Bold", size: 30)
        let token:Bool = (UserDefaults.string(forKey: .vip) != nil)
        
        if token == true {
            vipLabel.text = "已开通vip"
        }else{
            vipLabel.text = "未开通vip"
        }
        
        setUICollectionView()
        
        paomadengAction()
        
    }


    @IBAction func payAction(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "商品未配置")
        SVProgressHUD.dismiss(withDelay: 1)
    
        
//        return
        
        let user = BmobUser.current()
        user?.setObject("1", forKey: "vip")
        user?.updateInBackground { (isSuccessful, error) in
            
            if(isSuccessful){
                
                print("恭喜您开通会员")
                
            }else{
                print("====\(error)")
            }

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
        let dataTitle = ["月卡会员（折合¥0.67/天）","季卡会员（折合¥0.67/天）","年卡会员（折合¥0.67/天）"]
        
        cell.money.text = dataMoney[indexPath.row]
        cell.title.text = dataTitle[indexPath.row]
        
        print(cell.bounds.size.height)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击图片\(indexPath.row)")
        
    }
}
