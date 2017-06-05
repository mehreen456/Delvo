//
//  OrderDetailVc.swift
//  Delvo
//
//  Created by Apple on 05/06/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class OrderDetailVc: UIViewController {

    @IBOutlet weak var PickAddress: UILabel!
    @IBOutlet weak var DropAddress: UILabel!
    @IBOutlet weak var PickContact: UILabel!
    @IBOutlet weak var PickName: UILabel!
    @IBOutlet weak var PickTime: UILabel!
    @IBOutlet weak var PickDate: UILabel!
    @IBOutlet weak var DropName: UILabel!
    @IBOutlet weak var PickOrderD: UILabel!
    @IBOutlet weak var DropContact: UILabel!
    @IBOutlet weak var DropTime: UILabel!
    @IBOutlet weak var DropOrderD: UILabel!
    @IBOutlet weak var DropDate: UILabel!
    @IBOutlet weak var DetailView: UIView!
    var orderNum = 0
    let dmobj = DelvoMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let details =  UserDefaults.standard.value(forKey: "MyOrder") as! [[String:Dictionary<String, String>]] as [NSDictionary]
        let order = details[orderNum] as! [String:Dictionary<String, String>]
        
        let pick = order["PickTask"]
        PickAddress.text = pick?["address"]
        PickContact.text = pick?["contact"]
        PickOrderD.text = pick?["details"]
        PickName.text = pick?["name"]
        
        let drop = order["DropTask"]
        DropAddress.text = drop?["address"]
        DropContact.text = drop?["contact"]
        DropOrderD.text = drop?["details"]
        DropName.text = drop?["name"]

        let orderTime = order["order"]
        PickDate.text = orderTime?["PickDate"]
        PickTime.text = orderTime?["PickTime"]
        DropDate.text = orderTime?["DropDate"]
        DropTime.text = orderTime?["DropTime"]
        
        let viewHeight = self.dmobj.heightForView(text:self.PickAddress.text!, frame:self.PickAddress.frame,size: 13.0) + self.dmobj.heightForView(text:self.DropAddress.text!, frame:self.DropAddress.frame,size: 13.0) + self.dmobj.heightForView(text:self.DropOrderD.text!, frame:self.DropOrderD.frame,size: 13.0) + self.dmobj.heightForView(text:self.PickOrderD.text!, frame:self.PickOrderD.frame,size: 13.0) + 330
        
        self.dmobj.AddBorder(height: viewHeight ,view: DetailView)
    }

    
}
