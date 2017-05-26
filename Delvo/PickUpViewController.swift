//
//  PickUpViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PickUpViewController: UIViewController ,SWRevealViewControllerDelegate {
    
    @IBAction func DropDetailButtonA(_ sender: Any) {
        
       self.performSegue(withIdentifier: "GoDropD", sender: self)
        
    }
    @IBAction func DropLocButtonA(_ sender: Any) {
       
      self.performSegue(withIdentifier: "DropLoc", sender: self)
    }
    @IBAction func PickDetailButtonA(_ sender: Any) {
      
      self.performSegue(withIdentifier: "Proceed", sender: self)
        
    }
    
    
    @IBOutlet weak var DropLocButton: UIButton!
    @IBOutlet weak var DropDView: UIView!
    @IBOutlet weak var DropLocLine: UIView!
    @IBOutlet weak var DropDetailButton: UIButton!
    @IBOutlet weak var PickDetailButton: UIButton!
    @IBOutlet weak var PickDetailLine: UIView!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var Mapview: UIView!
    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var PickUpView: UIView!
    
    var MapVC: MapViewController?
    let obj = DelvoMethods()
    let objOD = OrderDescClassMethods()
    let ToastMsgPickUp = "Please enter pick address to proceed"
    let ToastMsgNearBy = "Please select near by place"
    let DefaultText = "Near by location"
    let ProceedSegue = "Proceed"
    let SearchSegue = "Search"
    let TitleVc = "PickUp"
    let NotificationName = "GetArea"
    let MapVcIdentifier = "PickUpVc"
    let diposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setview()
        self.notification()
        self.PickUpView.SetCorners(radius: 5)
        obj.AddGesture(controller:self)
        self.revealViewController().rightViewRevealWidth = self.view.frame.width - 55
        obj.navBar(controller:self,Title:TitleVc)
       
        // objOD.EmptyUserDefaults()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.revealViewController().delegate = self
        MapVC?.controller = MapVcIdentifier
       
        if MoveToVc.visitPD {
            
            PickDetailLine.backgroundColor = UIColor.white
            self.PickDetailButton.setImage(UIImage(named:"bagEnable"), for: .normal)
            PickDetailButton.isUserInteractionEnabled = true
        }
        
        if MoveToVc.visitDL{
            
                DropLocLine.backgroundColor = UIColor.white
                self.DropLocButton.setImage(UIImage(named:"DropEnable"), for: .normal)
                DropLocButton.isUserInteractionEnabled = true
        }
        
        if MoveToVc.visitDD{
            
            DropDView.backgroundColor = UIColor.white
            self.DropDetailButton.setImage(UIImage(named:"bagEnable"), for: .normal)
            DropDetailButton.isUserInteractionEnabled = true
        }
        
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
        self.ToastView.isHidden = true
    }

    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func notification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue:NotificationName), object: nil)}
    
    func GetArea(_ notification: NSNotification) {
       
        PickUpLocation.text = Pick_Detail.PickLocation
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
}
