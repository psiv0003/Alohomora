//
//  SettingsViewController.swift
//  Alohomora
//
//  Created by Poornima Sivakumar on 6/11/19.
//  Copyright © 2019 Poornima Sivakumar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

 
    @IBOutlet weak var photoGalleryView: UIView!
    @IBOutlet weak var helpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

      viewSet()
    }
    
    
    func viewSet(){
        photoGalleryView.layer.masksToBounds = false
        photoGalleryView.clipsToBounds = true
        
        photoGalleryView.layer.cornerRadius = 10
        photoGalleryView.layer.shadowOffset = CGSize(width: -1, height: 1)
        photoGalleryView.layer.shadowOpacity = 0.2
        
        
        helpView.layer.masksToBounds = false
        helpView.clipsToBounds = true
        helpView.layer.cornerRadius = 10
        helpView.layer.shadowOffset = CGSize(width: -1, height: 1)
        helpView.layer.shadowOpacity = 0.2
    }
    
    @IBAction func helpButton(_ sender: Any) {
    }
    @IBAction func photoGalleryButton(_ sender: Any) {
    }
    

}
