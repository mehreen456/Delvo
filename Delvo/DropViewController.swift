
//
//  DropViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DropViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var ToastView: UIView!

    @IBOutlet weak var DropLocationLabel: UILabel!
    @IBOutlet weak var GoDelvoButton: UIButton!
    @IBOutlet weak var DropAddress: UITextField!
    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var DropLocation: UILabel!
    @IBOutlet weak var DropView: UIView!
    @IBOutlet weak var PickUpView: UIView!
    @IBOutlet weak var MapView: UIView!
    var MapVC: MapViewController?
    var obj = DelvoMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ShowMapView()
        self.navBar()
        DropAddress.delegate = self
        PickUpLocation.text = MapViewController.Location.PickLocation
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: "GetArea"), object: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DropViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.PickUpView.backgroundColor = obj.DarkBlueColor()
        self.GoDelvoButton.backgroundColor = obj.ButtonColor()
        self.ToastView.isHidden=true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func GetArea(_ notification: NSNotification) {
        
        DropLocation.text = MapViewController.Location.DropLocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        MapVC?.controller = "DropVc"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//       let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if appDelegate.FirstLoad {
//             appDelegate.FirstLoad = false }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search"{
            
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.PickUpLocation.text!
            searchVc.delegate = MapVC as Address?
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func ShowMapView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        MapVC = storyboard.instantiateViewController(withIdentifier: "MapVc") as? MapViewController
        addChildViewController(MapVC!)
        MapVC?.view.frame = self.MapView.bounds
        MapView.addSubview((MapVC?.view)!)
        MapVC?.didMove(toParentViewController:self)
    }
    
    func navBar(){
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Menu.png"), for: UIControlState.normal)
        button.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.rightRevealToggle(_:)), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.title = "Drop Location"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    @IBAction func ChangePIckButton(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        Drop_Address.DropAddress = self.DropAddress.text!
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "GoDelvo"{
            
            guard let text = DropAddress.text, !text.isEmpty else {
                
             obj.Toast(view: self.view, ToastView: self.ToastView, message:"Please enter pick address to proceed")
                return false
            }
            
            guard PickUpLocation.text != "Near by location" else {
                
                obj.Toast(view: self.view, ToastView: self.ToastView, message:"Please select near by place")
                return false
            }
            
        }
        
        return true
    }
    
    struct Drop_Address{
        
        static var DropAddress = String()
    }
}
