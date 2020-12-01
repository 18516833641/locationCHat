//
//  friendTableViewCell.swift
//  LocationChat
//
//  Created by mark on 2020/10/28.
//

import UIKit

class friendTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userTime: UILabel!
    @IBOutlet weak var userHeader: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
