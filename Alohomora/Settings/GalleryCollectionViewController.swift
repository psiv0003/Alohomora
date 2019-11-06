//
//  GalleryCollectionViewController.swift
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

//private let reuseIdentifier = "Cell"

var tempImagesList: [ImageData] = []

class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "imageCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 3
    
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var imageNameList: [ImageData] = []
    
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
        
      //     self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
     
          
            
        let userID = Auth.auth().currentUser!.uid
        let basicQuery = Firestore.firestore().collection("UserData").document(userID).collection("Images")
        basicQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            let allDocuments = snapshot.documents
            for imageNames in allDocuments {
                
                do {
                    
                    //decoding the json and storing it in a sensor object format
                    let sData = try FirestoreDecoder().decode(ImageData.self, from: imageNames.data())
                    self.imageNameList.append(sData)
                    let fileName = sData.imgUrl
                    
                    if(self.imagePathList.contains(fileName)) {
                        print("Image already loaded in. Skipping image")
                        continue
                    }
                    
                    if let image = self.loadImageData(fileName: fileName) {
                        self.imageList.append(image)
                        print("im")
                        self.imagePathList.append(fileName)
                        self.collectionView!.reloadSections([0])
                    } else {
                        print("nahii")
                    }
                    
                    print(self.imageNameList)
                } catch let error {
                    print(error)
                }
                
            }
            
            tempImagesList = self.imageNameList
            //   self.tableView.reloadData()
            
        }
        
      
    
    }
    
    
    func getFileNames(){
    
        let userID = Auth.auth().currentUser!.uid
        let basicQuery = Firestore.firestore().collection("UserData").document(userID).collection("Images")
        basicQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            let allDocuments = snapshot.documents
            for imageNames in allDocuments {
                
                do {
                    
                    //decoding the json and storing it in a sensor object format
                    let sData = try FirestoreDecoder().decode(ImageData.self, from: imageNames.data())
                    self.imageNameList.append(sData)
                    print(self.imageNameList)
                } catch let error {
                    print(error)
                }
                
            }
            
            tempImagesList = self.imageNameList
         //   self.tableView.reloadData()
            
        }
    }
   
    

    func loadImageData(fileName: String) -> UIImage? {
         print("load image data")
         var image: UIImage?
         let userId = Auth.auth().currentUser!.uid
         let imgUrl = "\(userId)/user/\(fileName).jpeg"
         let islandRef = storageRef.child(imgUrl)
         islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                print("success")
                 image = UIImage(data: data!)
            }
        }
        
        return image
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
      //  return 1
        return imageList.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            as! ImageCollectionViewCell
        
        cell.backgroundColor = UIColor.lightGray
        cell.imageView.image = imageList[indexPath.row]
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAt
        section: Int) -> UIEdgeInsets {
        return sectionInsets
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt
        section: Int) -> CGFloat {
        return sectionInsets.left
    }


}
