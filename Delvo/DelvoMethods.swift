//
//  DelvoMethods.swift
//  Delvo
//
//  Created by Apple on 13/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Toast_Swift

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
    
    func Toast(view:UIView , ToastView:UIView , message:String)
    {
        var style = ToastStyle()
        style.messageColor = UIColor.white
        style.backgroundColor = self.DarkBlueColor()
        view.makeToast(message, duration: 2.0, position: ToastView.center, style:style)
    }
    
    func PrimaryBlueColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 14.0/255.0, green: 190.0/255.0, blue: 214.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    func DarkBlueColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 32.0/255.0, green: 136.0/255.0, blue: 171.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    func ButtonColor() -> UIColor
    {
        let myColor : UIColor = UIColor( red: 4.0/255.0, green: 189.0/255.0, blue: 214.0/255.0, alpha: 1.0 )
        return myColor
    }
    
    func alert(message: String, title: String = "" ) -> UIViewController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:nil)        
        
        alertController.addAction(OKAction)
        return alertController
    }
    
    func DismissAlertView(alertview:UIAlertController)
    {
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            alertview.dismiss(animated: true, completion: nil)}
            
    }
    
    func AddImageTextfield(textField:UITextField)
    {
        let image = UIImageView(image: UIImage(named: "SearchIcon"))
        image.frame = CGRect(x: 0.0, y: 0.0, width: 20, height:20)
        let paddingview = UIView()
        paddingview.frame = CGRect(x: 0.0, y: 0.0, width: image.frame.size.width + 10, height:image.frame.size.height)
        paddingview.addSubview(image)
        paddingview.contentMode = UIViewContentMode.center
        textField.rightView = paddingview
        textField.rightViewMode = UITextFieldViewMode.always
    }

}
