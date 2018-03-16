//
//  MyHaircutsFeedTableViewCell.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 1/31/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

class MyHaircutsFeedTableViewCell: UITableViewCell {

    @IBOutlet var haircutImage: UIImageView!
    @IBOutlet var haircutTitle: UILabel!
    @IBOutlet var haircutDescription: UILabel!
    @IBOutlet var haircutSalonTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
