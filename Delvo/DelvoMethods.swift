
//
//  DelvoMethods.swift
//  Delvo
//
//  Created by Apple on 13/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DelvoMethods: NSObject {

    func heightForView(text:String , frame:CGRect) -> CGFloat{
        
        let label:UILabel = UILabel(frame:frame)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font =  UIFont(name: "Helvetica", size: 15.0)
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func PrimaryBlueColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 0.0, green: 188.0, blue: 213.0, alpha: 1.0 )
        return myColor
    }
    
}
