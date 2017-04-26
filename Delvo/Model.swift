//
//  Model.swift
//  Delvo
//
//  Created by Apple on 08/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

struct Pick_Detail{
    
    static var PickLocation = String()
    static var PickAddress = String()
    static var PickName = String()
    static var PickContact = String()
    static var PickUpDetailAddress = String()
    static var PickUpTime = String()
    static var PickUpDate = String()
    static var PickUpDetail = String()
    static var PickUpAmount = String()

}

struct Drop_Detail{
    
    static var DropLocation = String()
    static var DropAddress = String()
    static var DropName = String()
    static var DropContact = String()
    static var DropDetailAddress = String()
    static var DropTime = String()
    static var DropDate = String()
    static var DropDetail = String()
    static var DropAmount = String()}

struct Location{
    
    static var PickLat = Double()
    static var PickLng = Double()
    static var DropLat = Double()
    static var DropLng = Double()
}

struct UserInfo{
    
    static var Name = String()
    static var Phone = String()
    static var Email = String()
    static var Password = String()
    static var image = Data()
    
}


