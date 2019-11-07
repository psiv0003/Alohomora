//
//  Device.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 8/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class Device: Codable {
    //var imgUrl: String
    var location: String
    
    
    init(location: String) {
        
        self.location = location
    }
}
