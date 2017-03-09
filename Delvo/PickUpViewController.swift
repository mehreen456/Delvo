//
//  PickUpViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class PickUpViewController: UIViewController ,SWRevealViewControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var PickAddress: UITextField!
    @IBOutlet weak var SideMenuButton: UIBarButtonItem!
    @IBOutlet weak var Mapview: UIView!
    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var ProceedButton: UIButton!
    @IBOutlet weak var PickUpView: UIView!
    
    var MapVC: MapViewController?
    let obj = DelvoMethods()
    
    let ToastMsgPickUp = "Please enter pick address to proceed"
    let ToastMsgNearBy = "Please select near by place"
    let DefaultText = "Near by location"
    let ProceedSegue = "Proceed"
    let SearchSegue = "Search"
    let TitleVc = "PickUp"
    let NotificationName = "GetArea"
    let MapVcIdentifier = "PickUpVc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setview()
        self.notification()
        obj.AddGesture(controller:self)
        obj.navBar(controller:self,Title:TitleVc )
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navController = self.navigationController!
        let objOD = OrderDescClassMethods()
      //  objOD.EmptyUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.revealViewController().delegate = self
        MapVC?.controller = MapVcIdentifier
    }
    
    // Mark ~ Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SearchSegue
        {
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.PickUpLocation.text!
            searchVc.delegate = MapVC as Address?
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == ProceedSegue {
            
            guard let text = PickAddress.text, !text.isEmpty else {
                MapVC?.locationManager.startUpdatingLocation()
                obj.Toast(view: self.view, ToastView: self.ToastView, message:ToastMsgPickUp)
                return false
            }
            
            guard PickUpLocation.text !=  DefaultText && PickUpLocation.text != "" else {
                
                obj.Toast(view: self.view, ToastView: self.ToastView, message:ToastMsgNearBy)
                return false
            }
        }
        return true
    }
    
    // Mark ~ Controller Methods
    
    func setview(){
        
        MapVC = obj.ShowMapView(controller: self,Mapview:self.Mapview)
        PickAddress.delegate = self
        self.ToastView.isHidden = true
        self.ProceedButton.backgroundColor = UIColor.ButtonColor()
        
    }

    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func notification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue:NotificationName), object: nil)
    }
    
    func GetArea(_ notification: NSNotification) {
       
        
        PickUpLocation.text = Location.PickLocation
    }
    
    // Mark ~ Delegate Methods
    
    func revealController(_ revealController: SWRevealViewController!, animateTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.leftSide{
            self.MapVC?.MapView.isUserInteractionEnabled = false
            obj.AddTapPanGesture(controller: self)
        }
        else{
            self.MapVC?.MapView.isUserInteractionEnabled = true }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        Pick_Address.PickAddress = self.PickAddress.text!
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}
