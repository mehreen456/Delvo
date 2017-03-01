
//
//  DropViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DropViewController: UIViewController ,SWRevealViewControllerDelegate, UITextFieldDelegate {
    
    struct Drop_Address{
        
        static var DropAddress = String()
    }
    
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var GoDelvoButton: UIButton!
    @IBOutlet weak var DropAddress: UITextField!
    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var DropLocation: UILabel!
    @IBOutlet weak var DropView: UIView!
    @IBOutlet weak var PickUpView: UIView!
    @IBOutlet weak var MapView: UIView!
    
    var MapVC: MapViewController?
    var obj = DelvoMethods()
    
    let ToastMsgDrop = "Please enter drop address to proceed"
    let ToastMsgNearBy = "Please select near by place"
    let DefaultText = "Near by location"
    let GoDelvoSegue = "GoDelvo"
    let SearchSegue = "Search"
    let TitleVc = "Drop Location"
    let NotificationName = "GetArea"
    let MapVcIdentifier = "DropVc"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        MapVC = obj.ShowMapView(controller: self,Mapview:self.MapView)
        obj.navBar(controller: self, Title: TitleVc)
        obj.AddGesture(controller: self)
        self.setTextFields()
        self.setColors()
        self.notification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.revealViewController().delegate = self
        MapVC?.controller = MapVcIdentifier
    }
    
    @IBAction func ChangePIckButton(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    // Mark ~ Delegate Methods
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        Drop_Address.DropAddress = self.DropAddress.text!
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.leftSide{
            self.MapVC?.MapView.isUserInteractionEnabled = false
            obj.AddTapPanGesture(controller: self)
        }
        else{
            self.MapVC?.MapView.isUserInteractionEnabled = true }
    }
    
   // Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SearchSegue{
            
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.PickUpLocation.text!
            searchVc.delegate = MapVC as Address?
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == GoDelvoSegue{
            
            guard let text = DropAddress.text, !text.isEmpty else {
                
             obj.Toast(view: self.view, ToastView: self.ToastView, message: ToastMsgDrop)
                return false
            }
            
        guard DropLocation.text != DefaultText  && DropLocation.text != "" else {
                
                obj.Toast(view: self.view, ToastView: self.ToastView, message:ToastMsgNearBy)
                return false
            }
        }
        return true
    }
    
    // Class Methods
    
    func setColors(){
        
        self.PickUpView.backgroundColor = UIColor.DarkBlueColor()
        self.GoDelvoButton.backgroundColor = UIColor.ButtonColor()
    }
    
    func notification(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: NotificationName), object: nil)
    }
    
    func GetArea(_ notification: NSNotification) {
        
        DropLocation.text = MapViewController.Location.DropLocation
    }
    
    
    func setTextFields(){
        
        DropAddress.delegate = self
        PickUpLocation.text = MapViewController.Location.PickLocation
        DropLocation.text = MapViewController.Location.DropLocation
        self.ToastView.isHidden=true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
}
