//
//  LinkDeviceViewController.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 30/10/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LinkDeviceViewController: UIViewController {

    var db: Firestore!

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var deviceId: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()

        //checkDevice()
        // Do any additional setup after loading the view.
    }
    
    func checkDevice(){
        db.collection("Devices").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                   // print("\(document.documentID) => \(document.data())")
                    print(document.documentID)
                    //the id entered by the user exists in teh "Devices" collection
                    
                    if( self.deviceId.text == document.documentID){
                        print("same same " + document.documentID)
                        let userID = Auth.auth().currentUser!.uid

                        // adding to the user table
                        //reference - https://firebase.google.com/docs/firestore/data-model
                        self.db
                            .collection("UserData").document(userID)
                            .collection("Devices").document(document.documentID)
                        .setData([
                            "location": self.locationTextField.text ?? "Main door"
                           
                        ]) { err in
                            if err != nil {
                                let alertController = UIAlertController(title: "Error", message: "Oops! Looks like something went wrong. Please try again or contact customer support at help@alohomora.com", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                 self.performSegue(withIdentifier: "linkToHomeSegue", sender: self)
                                print("Document successfully written!")
                            }
                        }


                    }else {
                        
                        let alertController = UIAlertController(title: "Error", message: "Oops! Looks like that ID does not exsist. Please contact customer support at help@alohomora.com", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

  
    func updateDevicesTable(){
        
    }
    
    @IBAction func link(_ sender: Any) {
        
        if (deviceId.text!.isEmpty && locationTextField.text!.isEmpty ){
            let alertController = UIAlertController(title: "Error", message: "Please enter the required data.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            checkDevice()
        }
    }
}
