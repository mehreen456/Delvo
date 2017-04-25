


//
//  SearchModel.swift
//  Delvo
//
//  Created by Apple on 18/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

struct SearchResult{
    
    let place:String
    let placeId: String
    
    init(place:String ,id: String ){
        
        self.place = place
        self.placeId = id
    }
}
