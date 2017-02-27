//
//  UIImageView+ChangeTintColor.swift
//  Delvo
//
//  Created by Apple on 20/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func ChangeTintColor(color:UIColor){
        
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
