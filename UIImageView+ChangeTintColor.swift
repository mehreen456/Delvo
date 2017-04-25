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
    
    
    func GetCircularImage(){
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}

extension UITextField {
    func setBottomBorder() {
        
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIView {
    func SetCorners(){
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func addBorder(){
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func addRedBorder(){
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
    }

    func removeBorder(){
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
    }

}
