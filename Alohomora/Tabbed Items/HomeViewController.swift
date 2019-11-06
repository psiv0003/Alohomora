//
//  HomeViewController.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 6/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import CodableFirebase
import UserNotifications

class HomeViewController: UIViewController {

    var db: Firestore!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        let storage = Storage.storage()
        storageRef = storage.reference()

        listenForChanges()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func listenForChanges() {
        let userID = Auth.auth().currentUser!.uid
        db.collection("motionSensor").whereField("userid", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New city: \(diff.document.data())")
                        self.notification()
                    }
                
                }
        }

    }
  

    func notification(){
        
        
        let content = UNMutableNotificationContent()
        content.title = "Melbourne Sights"
        content.subtitle = "Sight Alert!"
        content.body = "Hey Looks like you just left a historical sight!"
        let imageName = "logo"
        // guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        
        //  let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        
        //  content.attachments = [attachment]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 4
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
