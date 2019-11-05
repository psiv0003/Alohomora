//
//  ContactsTableViewController.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 5/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import CodableFirebase
import SDWebImage


var tempContactList: [Contacts] = []
class ContactsTableViewController: UITableViewController {
    
    let SECTION_PARTY = 0;
    let SECTION_COUNT = 1;
    let CELL = "contactsCell"
    var storageRef: StorageReference!
    var contactList: [Contacts] = []
    var db: Firestore!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        let storage = Storage.storage()
        storageRef = storage.reference()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contactList.removeAll()
        //tableView.reloadData()
        loadUserData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
           
        let contactCell = tableView.dequeueReusableCell(withIdentifier: CELL, for: indexPath) as! ContactsTableViewCell
        let contact = contactList[indexPath.row]
        contactCell.nameTxt.text = contact.firstName
        if(contact.trustedContact == 0){
            contactCell.isTrustedImageView.isHidden = true
        }
        //get the user's profile image
            let islandRef = storageRef.child(contact.imgUrl)
            islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                    // Uh-oh, an error occurred!
                } else {
                    print("image")
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    
//                    contactCell.userImageView.sd_setImageWithStorageReference(storageRef, placeholderImage: placeholderImage)

                    contactCell.userImageView.image = image
                }

            }
        return contactCell
    }
            
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            self.contactList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func loadUserData(){
          print("DATAaaaa")
        //getting data from firebase and ordering it by time
        //references: https://codelabs.developers.google.com/codelabs/firebase-cloud-firestore-workshop-swift/index.html?index=..%2F..index#3
        let userID = Auth.auth().currentUser!.uid
        print(userID)
        let basicQuery = Firestore.firestore().collection("UserData").document(userID).collection("Contacts")
        basicQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            let allDocuments = snapshot.documents
            for sensortDoc in allDocuments {
              
                do {
                    
                    //decoding the json and storing it in a sensor object format
                    let sData = try FirestoreDecoder().decode(Contacts.self, from: sensortDoc.data())
                    self.contactList.append(sData)
                    print(sData.firstName)
                } catch let error {
                    print(error)
                }
                
            }
            
            tempContactList = self.contactList
            self.tableView.reloadData()
            
        }
    }
}
