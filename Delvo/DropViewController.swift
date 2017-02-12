
//
//  DropViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DropViewController: UIViewController {

    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var DropLocation: UILabel!
    @IBOutlet weak var MapView: UIView!
    var MapVC: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ShowMapView()
        self.navBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: "GetArea"), object: nil)

    }
    
    func GetArea(_ notification: NSNotification) {
        
        DropLocation.text = MapViewController.Location.DropLocation
        PickUpLocation.text = MapViewController.Location.PickLocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        MapVC?.controller = "DropVc"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search"
        {
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.PickUpLocation.text!
            searchVc.delegate = MapVC as Address?
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.navigationController?.navigationItem.title , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        else{
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
    
    func ShowMapView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        MapVC = storyboard.instantiateViewController(withIdentifier: "MapVc") as? MapViewController
        addChildViewController(MapVC!)
        MapVC?.view.frame = self.MapView.bounds
        MapView.addSubview((MapVC?.view)!)
        MapVC?.didMove(toParentViewController:self)
    }
    
    func navBar()
    {
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

   
}
