//
//  MotionVideo.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 8/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase

class MotionVideo: UIViewController {

    var motionObj: Motion?
    var storageRef: StorageReference!
    var db: Firestore!
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = Storage.storage()
        storageRef = storage.reference()
        userID = Auth.auth().currentUser!.uid
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        return true
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        
        let starsRef = storageRef.child(motionObj!.video_url)
        print("HHHHH")
        print(starsRef)
        // Fetch the download URL
        starsRef.getData(maxSize: 1 * 1024 * 1024) { data, error in

            if let error = error {
                // Handle any errors
                print(error)
            } else {
//                guard let url = URL(string: "\(data.down)") else {
//                    return
//                }
                // Create an AVPlayer, passing it the HTTP Live Streaming URL.
                let player = AVPlayer(url: url)
                
                // Create a new AVPlayerViewController and pass it a reference to the player.
                let controller = AVPlayerViewController()
                controller.player = player
                
                // Modally present the player and call the player's play() method when complete.
                self.present(controller, animated: true) {
                    player.play()
                }
                // Get the download URL for 'images/stars.jpg'
            }
        }
        
    
    }
}
