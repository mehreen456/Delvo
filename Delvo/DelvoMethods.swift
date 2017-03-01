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
        style.backgroundColor = UIColor.DarkBlueColor()
        view.makeToast(message, duration: 2.0, position: ToastView.center, style:style)
    }
    
       
    func AddImageTextfield(textField:UITextField){
        
        let image = UIImageView(image: UIImage(named: "SearchIcon"))
        image.frame = CGRect(x: 0.0, y: 0.0, width: 20, height:20)
        let paddingview = UIView()
        paddingview.frame = CGRect(x: 0.0, y: 0.0, width: image.frame.size.width + 10, height:image.frame.size.height)
        paddingview.addSubview(image)
        paddingview.contentMode = UIViewContentMode.center
        textField.rightView = paddingview
        textField.rightViewMode = UITextFieldViewMode.always
    }
    
    func AddTapPanGesture(controller:UIViewController){
        
        controller.view.addGestureRecognizer(controller.revealViewController().tapGestureRecognizer())
        controller.view.addGestureRecognizer(controller.revealViewController().panGestureRecognizer())
    }

    func AddGesture(controller:UIViewController){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: controller, action: #selector(PickUpViewController.dismissKeyboard))
        controller.view.addGestureRecognizer(tap)
    }
    
    func ShowMapView(controller:UIViewController, Mapview:UIView) -> MapViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MapVC = storyboard.instantiateViewController(withIdentifier: "MapVc")  as? MapViewController
        controller.addChildViewController(MapVC!)
        MapVC?.view.frame = Mapview.bounds
        Mapview.addSubview((MapVC?.view)!)
        MapVC?.didMove(toParentViewController: controller)
        return MapVC!
    }
    
    func navBar(controller:UIViewController,Title:String){
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Menu.png"), for: UIControlState.normal)
        button.addTarget(controller.revealViewController(), action:#selector(SWRevealViewController.rightRevealToggle(_:)), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem.init(customView: button)
        controller.navigationItem.rightBarButtonItem = barButton
        controller.navigationItem.title = Title
        controller.navigationController?.navigationBar.tintColor = UIColor.white
        controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }



}
