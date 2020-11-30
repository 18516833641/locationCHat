//
//  AnalyticsViewController.swift
//  LocationChat
//
//  Created by Mac on 2020/10/27.
//

import UIKit

class AnalyticsViewController: UIViewController {
    
    let KScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    let KScreenHeight: CGFloat = UIScreen.main.bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .groupTableViewBackground
        
        let leftBarBtn = UIButton()
        leftBarBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftBarBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        leftBarBtn.setBackgroundImage(UIImage(named: "back"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(backToPrevious), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtn)
    }

    //返回按钮点击响应
       @objc func backToPrevious(){
           self.navigationController!.popViewController(animated: true)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //在这里全局设置状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
extension String {
 /// 替换手机号中间四位
    ///
    /// - Returns: 替换后的值
    func replacePhone() -> String {
        let start = self.index(self.startIndex,offsetBy: 3)
        let end = self.index(self.startIndex,offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start,upper: end))
        return self.replacingCharacters(in: range,with: "****")
    }
}
