//
//  MyOrderCell.swift
//  Delvo
//
//  Created by Apple on 02/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var Pick: UILabel!
    @IBOutlet weak var PickUpLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var OrderLabel: UILabel!
    @IBOutlet weak var Drop: UILabel!
    @IBOutlet weak var Order: UILabel!
    @IBOutlet weak var Time: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        PickUpLabel.textColor = UIColor.DarkBlueColor()
        DropLabel.textColor = UIColor.DarkBlueColor()
        TimeLabel.textColor = UIColor.DarkBlueColor()
        OrderLabel.textColor = UIColor.DarkBlueColor()
        Drop.textColor = UIColor.DarkBlueColor()
        Order.textColor = UIColor.DarkBlueColor()
        Time.textColor = UIColor.DarkBlueColor()
        Pick.textColor = UIColor.DarkBlueColor()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
