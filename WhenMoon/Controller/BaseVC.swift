//
//  BaseVC.swift
//  BaseVC
//
//  Created by Ryan Zander on 1/26/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, UITextFieldDelegate {
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add logo to nav bar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 112, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WhenMoonLogo.png")
        let logoView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        logoView.addSubview(imageView)
        navigationItem.titleView = logoView
       
    }

 
    // dismiss keyboard if user touches the background area
    // in the Storyboard, change the view to UIControl and add TouchUpInside event
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        
        self.view.endEditing(true)
    }
    
    
    // show a basic alert with "OK" to dismiss
    func showAlertWith(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default,  handler: { action in
            // if we had a refresh spinner going, stop it
            self.refreshControl.endRefreshing()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
