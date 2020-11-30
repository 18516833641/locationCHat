//
//  addFriendViewController.swift
//  LocationChat
//
//  Created by mark on 2020/10/28.
//

import UIKit

class addFriendViewController: AnalyticsViewController {

    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.attributedPlaceholder = NSAttributedString.init(string:"输入想要查询的手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 0.05, green: 0.77, blue: 1, alpha: 1)])
        
        title1.textColor =  UIColor(red: 0.05, green: 0.77, blue: 1, alpha: 1)
        title2.textColor = UIColor(red: 0.05, green: 0.77, blue: 1, alpha: 1)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buttonAction(_ sender: Any) {
        
        
    }
    
}

