//
//  UIColor+AddColor.swift
//  Delvo
//
//  Created by Apple on 19/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

extension UIColor{
    
  
    class func PrimaryGrayColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    class func ToastViewColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 70.0/255.0, green: 27.0/255.0, blue: 70.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    class func DoneButtonColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 255.0/255.0, green: 126.0/255.0, blue: 7.0/255.0, alpha: 1.0 )
        return myColor
    }

}
