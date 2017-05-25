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

    
    func heightForView(text:String , frame:CGRect,size:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame:frame)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font =  UIFont(name: "Helvetica", size: size)
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func Toast(view:UIView , ToastView:UIView , message:String)
    {
        var style = ToastStyle()
        style.messageColor = UIColor.white
        style.backgroundColor = UIColor.ToastViewColor()
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
        button.setImage(UIImage.init(named: "MenuButton"), for: UIControlState.normal)
        button.addTarget(controller.revealViewController(), action:#selector(SWRevealViewController.rightRevealToggle(_:)), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width:25, height:17)
        let barButton = UIBarButtonItem.init(customView: button)
        button.tintColor = UIColor.white
        controller.navigationItem.rightBarButtonItem = barButton
        controller.navigationItem.title = Title
        controller.navigationController?.navigationBar.tintColor = UIColor.white
        controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        controller.navigationItem.hidesBackButton = true
       
    }

    func drawLine(startPoint:CGPoint ,endPoint:CGPoint, view:UIView) {
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        let dashes:[CGFloat] = [4, 2]
        linePath.setLineDash(dashes, count: 2, phase: 0)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.lightGray.cgColor
        line.lineWidth = 1
        line.lineJoin = kCALineJoinRound
        view.layer.addSublayer(line)
    }
    
    func AddBorder(height:CGFloat , view:UIView){
        
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        view.layer.masksToBounds = true
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width:7, height: height+5)
        border.backgroundColor = UIColor.ToastViewColor().cgColor
        view.layer.addSublayer(border)
    }
}
