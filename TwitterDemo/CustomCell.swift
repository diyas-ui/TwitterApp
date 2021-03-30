//
//  CustomCell.swift
//  TwitterDemo
//
//  Created by mac on 12/3/20.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
