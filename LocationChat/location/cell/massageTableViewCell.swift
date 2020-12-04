//
//  massageTableViewCell.swift
//  LocationChat
//
//  Created by mark on 2020/11/11.
//

import UIKit

class massageTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
