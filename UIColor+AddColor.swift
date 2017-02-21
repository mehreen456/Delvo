//
//  UIColor+AddColor.swift
//  Delvo
//
//  Created by Apple on 19/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

extension UIColor{
    
  
    class func PrimaryBlueColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 14.0/255.0, green: 190.0/255.0, blue: 214.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    class func DarkBlueColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 32.0/255.0, green: 136.0/255.0, blue: 171.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    class func ButtonColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 4.0/255.0, green: 189.0/255.0, blue: 214.0/255.0, alpha: 1.0 )
        return myColor
    }

}
