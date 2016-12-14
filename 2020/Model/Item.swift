//
//  Item.swift
//  2020
//
//  Created by Miriam Hendler on 12/6/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var name: String = ""
    var imageName: String
    var wasteType: Waste = .none
    
    init(imageName: String) {
        self.imageName = imageName
        setWasteTypeAndName()
    }
    
    func setWasteTypeAndName() {
        if imageName.contains("_rec") {
            wasteType = .recycle
        } else if imageName.contains("_com") {
            wasteType = .compost
        } else if imageName.contains("_lan"){
            wasteType = .landfill
        } else {
            wasteType = .none
        }
        
        name = imageName.components(separatedBy: "_")[0].uppercased()
    }
}
