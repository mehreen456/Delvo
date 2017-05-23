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
    
    
    func GetCircularImage(color:CGColor){
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = color
    }
}

extension UIImage {
    
    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = self.size.width + x
        let height: CGFloat = self.size.width + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - self.size.width) / 2, y: (height - self.size.height) / 2)
        self.draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
}

extension UITextField {
//    func setBottomBorder() {
//        
//        self.borderStyle = .none
//        self.layer.backgroundColor = UIColor.white.cgColor
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.ToastViewColor().cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
//    }
}

extension UITextField {
    
    func roundCorner(radius:CGFloat){
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func AddButtonBorder(color:CGColor,width:CGFloat){
        
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
}

extension UIView {
   
    func SetCorners(radius:CGFloat){
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addBorder(color:CGColor,width:CGFloat){

        
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
    func addRedBorder(){
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
    }

    func removeBorder(){
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
    }
    
    func setBottomBorder() {
        
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.ToastViewColor().cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }


}
