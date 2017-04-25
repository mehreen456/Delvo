//
//  MyOrderCell.swift
//  Delvo
//
//  Created by Apple on 02/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var PickUpLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var OrderLabel: UILabel!
    @IBOutlet weak var UserContact: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var GreenCircle: UIImageView!
    @IBOutlet weak var LineView: UIView!
  
    @IBOutlet weak var RedCircle: UIImageView!
    let delvoMethods = DelvoMethods()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.delvoMethods.drawLine(startPoint: CGPoint(x: contentView.frame.origin.x + 20 , y:  UserContact.frame.origin.y +  UserContact.frame.size.height + 5), endPoint:  CGPoint(x:contentView.frame.origin.x + CellView.frame.size.width - 20 , y: UserContact.frame.origin.y +  UserContact.frame.size.height + 5), view: CellView)
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
