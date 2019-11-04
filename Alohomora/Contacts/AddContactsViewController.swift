//
//  AddContactsViewController.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 1/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddContactsViewController: UIViewController {
    
    var db: Firestore!
    var isTrusted = -99

    
    @IBOutlet weak var firstnameTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var swtichController: UISwitch!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    
    @IBOutlet weak var numberTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()


    }
    
   
    @IBAction func saveContact(_ sender: Any) {
        
        let userID = Auth.auth().currentUser!.uid
        
        if (firstnameTxt.text!.isEmpty && lastnameTxt.text!.isEmpty && phoneNumberTxt.text!.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "Please enter the required data.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            if ( swtichController.isOn) {
                isTrusted = 1
            }else {
                isTrusted = 0
            }
            let name = firstnameTxt.text! +  "-" + lastnameTxt.text!

            //reference - https://firebase.google.com/docs/firestore/data-model
            self.db
                .collection("UserData").document(userID)
                .collection("Contacts").document(name)
                .setData([
                    "firstName": self.firstnameTxt.text!,
                    "lastName": self.lastnameTxt.text!,
                    "phoneNumber": self.phoneNumberTxt.text!,
                    "trustedContact": isTrusted
                    
                ]) { err in
                    if err != nil {
                        let alertController = UIAlertController(title: "Error", message: "Oops! Looks like something went wrong. Please try again or contact customer support at help@alohomora.com", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)

                        //self.performSegue(withIdentifier: "linkToHomeSegue", sender: self)
                        print("Document successfully written!")
                    }
            }
        }
        

    }
    
    
}
