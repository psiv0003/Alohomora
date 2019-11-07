//
//  Motion.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 8/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class Motion: Codable {
    var video_url: String
    let time: Timestamp
    var userId: String
    
    
    init(video_url: String, time: Timestamp, userId: String) {
        
        self.video_url = video_url
        self.time = time
        self.userId = userId
       
    }
}
extension Timestamp: TimestampType {}
