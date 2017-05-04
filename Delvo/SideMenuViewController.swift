//
//  SideMenuViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SideMenuViewController: UIViewController {

    @IBOutlet weak var MenuTable: UITableView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var LogoImage: UIImageView!
  
    let cellIdentifier = "SideMenuCell"
    let delvoMethod = DelvoMethods()
    let obj = OrderDescClassMethods()
    
    let Menu = Observable.just([
        
        SideMenuItems(item:"Home",image:UIImage(named:"Home")!),
        SideMenuItems(item:"My Orders",image:UIImage(named:"Orders")!),
        SideMenuItems(item:"Profile",image:UIImage(named:"Profile")!),
        SideMenuItems(item:"Sign Out",image:UIImage(named:"SignOut")!)
       
        ])
    
    let disposeBag = DisposeBag()
    var array:NSDictionary = [:]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.value(forKey: "User")) != nil{
           
           self.array =  UserDefaults.standard.value(forKey: "User") as! NSDictionary
           self.UserNameLabel.text = self.array["Name"] as! String?
        }
        
       self.TableData()
       self.notification()
       
    }
    
    func notification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue:"UpdateInfo"), object: nil)}
    
    func GetArea(_ notification: NSNotification) {
        
        array =  UserDefaults.standard.value(forKey: "User") as! NSDictionary
        UserNameLabel.text = array.value(forKey: "Name") as! String?
    }

    func TableData(){
        
        Menu.bindTo(MenuTable.rx.items(cellIdentifier: cellIdentifier)){ row,menuItem,cell in
            
            if let C_cell = cell as? SideTableCell{
                
                C_cell.TextLabel.text = menuItem.item
                C_cell.ImageView.image = menuItem.image
            }
            
            }.addDisposableTo(disposeBag)
        
        delvoMethod.drawLine(startPoint: CGPoint(x:LogoImage.frame.origin.x - 10 , y: LogoImage.frame.origin.y + LogoImage.frame.size.height + 5), endPoint:  CGPoint(x:LogoImage.frame.origin.x + LogoImage.frame.size.width , y: LogoImage.frame.origin.y + LogoImage.frame.size.height + 5), view: self.view)
        
        MenuTable.rx.modelSelected(SideMenuItems.self).subscribe(onNext:{ menuItem in
            
            
            if menuItem.item == "Home"{
                self.performSegue(withIdentifier: "Home", sender: self)
            }
                
            else if menuItem.item == "Sign Out"{
                
                UserDefaults.standard.removeObject(forKey: "UserToken")
                UserDefaults.standard.removeObject(forKey: "User")
                self.performSegue(withIdentifier: "SignIn", sender: self)
            }
                
            else{
                
                self.revealViewController().rightRevealToggle(animated: true)
                var destination = UIViewController()
               
                if menuItem.item == "My Orders"{
                    
                    let storyboard = UIStoryboard(name:"MyOrders", bundle: Bundle.main)
                    destination = storyboard.instantiateViewController(withIdentifier: "Orders") as! MyOrdersVC
                }
                
                else{
                    
                    let storyboard = UIStoryboard(name:"MyProfile", bundle: Bundle.main)
                    destination = storyboard.instantiateViewController(withIdentifier: "Profile") as! MyProfileVc
                }
             
                let nVC = self.revealViewController().frontViewController as! UINavigationController
                nVC.pushViewController(destination, animated: true)
            }
            
        }).addDisposableTo(disposeBag)
        MenuTable.alwaysBounceVertical = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let row = MenuTable.indexPathForSelectedRow {
            self.MenuTable.deselectRow(at: row, animated: false)
        }
    }
    
    }
