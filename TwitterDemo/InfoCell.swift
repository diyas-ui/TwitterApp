//
//  InfoCell.swift
//  TwitterDemo
//
//  Created by mac on 12/4/20.
//

import UIKit

class InfoCell: UITableViewCell {
    
    
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hashtaglabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
