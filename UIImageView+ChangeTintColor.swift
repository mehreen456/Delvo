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
}
