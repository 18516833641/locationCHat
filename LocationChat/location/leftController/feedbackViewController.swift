//
//  feedbackViewController.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
//

import UIKit

class feedbackViewController: AnalyticsViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "意见反馈"
    }

    @IBAction func downAction(_ sender: Any) {
        
    }
    
}
