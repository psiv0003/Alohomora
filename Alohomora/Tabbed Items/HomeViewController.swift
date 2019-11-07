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
    var userID = ""
    var storageRef: StorageReference!
    var contactList: [Contacts] = []
    var trustedList: [Contacts] = []
    var deviceList: [Device] = []

    @IBOutlet weak var deviceTotalTxt: UILabel!
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var totalTrustedTxt: UILabel!
    @IBOutlet weak var trustedView: UIView!
    @IBOutlet weak var totalContactsTxt: UILabel!
    @IBOutlet weak var contactsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        let storage = Storage.storage()
        storageRef = storage.reference()
        userID = Auth.auth().currentUser!.uid
        addShadow(view: deviceView)
        addShadow(view: trustedView)
        addShadow(view: contactsView)

        listenForChanges()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        getDeviceTotal()
    }

    
    
    func listenForChanges() {
        
        let userID = Auth.auth().currentUser!.uid
        db.collection("motionSensor").whereField("userId", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                      //  print("New city: \(diff.document.data())")
                        self.MotionNotification(data: "abcs")
                    }
                
                }
        }

        
        db.collection("pushButton").whereField("userId", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                      //  print("New city: \(diff.document.data())")
                        self.MotionNotification(data: "abcs")
                    }
                    
                }
        }
    }
  

    func MotionNotification(data: String){
        
        
        let content = UNMutableNotificationContent()
        content.title = "Movement Alert"
//        content.subtitle = "Sight Alert!"
        content.body = "Hey there! Motion was just detected outside your door. Check to see who it is!"
       // let imageName = "logo"
        // guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        
        //  let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        
        //  content.attachments = [attachment]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        // 4
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    func getData(){
        contactList.removeAll()
        trustedList.removeAll()
        //getting data from firebase and ordering it by time
        //references: https://codelabs.developers.google.com/codelabs/firebase-cloud-firestore-workshop-swift/index.html?index=..%2F..index#3
       
        print(userID)
        let basicQuery = Firestore.firestore().collection("UserData").document(userID).collection("Contacts")
        basicQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            let allDocuments = snapshot.documents
            for contacts in allDocuments {
                
                do {
                    
                    //decoding the json and storing it in a sensor object format
                    let sData = try FirestoreDecoder().decode(Contacts.self, from: contacts.data())
                    self.contactList.append(sData)
                    if( sData.trustedContact == 1){
                        self.trustedList.append(sData)
                    }
                  
                } catch let error {
                    print(error)
                }
                
            }
            
            self.totalContactsTxt.text = "\(self.contactList.count)"
            self.totalTrustedTxt.text = "\(self.trustedList.count)"

            
        }
        
    }
    
    func getDeviceTotal(){
        deviceList.removeAll()
        let basicQuery = Firestore.firestore().collection("UserData").document(userID).collection("Devices")
        basicQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            let allDocuments = snapshot.documents
            for devices in allDocuments {
                
                do {
                    
                    //decoding the json and storing it in a sensor object format
                    let sData = try FirestoreDecoder().decode(Device.self, from: devices.data())
                    self.deviceList.append(sData)
                   
                    
                } catch let error {
                    print(error)
                }
                
            }
            
            self.deviceTotalTxt.text = "\(self.deviceList.count)"
           
            
            
        }
    }
    
    func addShadow(view: UIView){
        
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 12.0
        view.layer.shadowOpacity = 0.7

    }
}
