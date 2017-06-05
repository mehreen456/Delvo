//
//  MyOrderCell.swift
//  Delvo
//
//  Created by Apple on 02/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

protocol OptionButtonsDelegate{
    func closeFriendsTapped(at index: Int)
}

class MyOrderCell: UITableViewCell {

    @IBAction func detailButton(_ sender: Any) {
        self.delegate?.closeFriendsTapped(at: indexPath)
    }
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var PickUpLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var GreenCircle: UIImageView!
    @IBOutlet weak var RedCircle: UIImageView!
   
    let delvoMethods = DelvoMethods()
    var delegate:OptionButtonsDelegate!
    var indexPath:Int!
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.detailButton.SetCorners(radius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
   
}
