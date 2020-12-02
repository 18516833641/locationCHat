//
//  vipCollectionViewCell.swift
//  LocationChat
//
//  Created by mark on 2020/11/19.
//

import UIKit

class vipCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vipIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var money: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        money.font = UIFont(name: "Helvetica-Bold", size: 15)
    }

}
