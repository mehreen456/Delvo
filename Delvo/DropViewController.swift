
//
//  DropViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DropViewController: UIViewController ,SWRevealViewControllerDelegate {
  
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var GoDelvoButton: UIButton!
    @IBOutlet weak var DropLocation: UILabel!
    @IBOutlet weak var DropView: UIView!
    @IBOutlet weak var MapView: UIView!
    @IBOutlet weak var DropDButton: UIButton!
    @IBOutlet weak var DropDLine: UIView!

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
    var delegate:Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MoveToVc.visitDL=true
        MoveToVc.PD_visitDL=true
        MapVC = obj.ShowMapView(controller: self,Mapview:self.MapView)
        obj.navBar(controller: self, Title: TitleVc)
        obj.AddGesture(controller: self)
        self.setTextFields()
        self.notification()
        self.revealViewController().delegate = self
        MapVC?.controller = MapVcIdentifier
        self.DropView.SetCorners(radius: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        if MoveToVc.DL_visitDD{
            
            DropDLine.backgroundColor = UIColor.white
            self.DropDButton.setImage(UIImage(named:"DropEnable"), for: .normal)
            DropDButton.isUserInteractionEnabled = true
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//            if Drop_Detail.DropLocation != ""{
//                MapVC?.GetMap(a: Location.DropLat, b: Location.DropLng)
//            }
//        
    }
    
    @IBAction func ChangePIckButton(_ sender: Any) {
        
       
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
    
   // Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SearchSegue{
            
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.DropLocation.text!
            searchVc.delegate = MapVC as Address?
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == GoDelvoSegue{
            
        guard DropLocation.text != DefaultText  && DropLocation.text != "" else {
                
                obj.Toast(view: self.view, ToastView: self.ToastView, message:ToastMsgNearBy)
                return false
            }
            return true
        }
        
        if identifier == SearchSegue{
        
            return true
        }

        return false
        
    }
    
    // Class Methods
    
    func notification(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: NotificationName), object: nil)
    }
    
    func GetArea(_ notification: NSNotification) {
        
        DropLocation.text = Drop_Detail.DropLocation
    }
    
    func setTextFields(){
        
        DropLocation.text = Drop_Detail.DropLocation
        self.ToastView.isHidden=true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func GoToPick(_ sender: Any) {
       // _ = self.navigationController?.popToRootViewController(animated: true)
      self.performSegue(withIdentifier: "GoPick", sender: self)
    }
    
    @IBAction func DropDButtonA(_ sender: Any) {
        self.performSegue(withIdentifier: GoDelvoSegue, sender: self)
    }
    @IBAction func GoToPickDetail(_ sender: Any) {
    
      self.performSegue(withIdentifier: "GoPickD", sender: self)
    }
}
