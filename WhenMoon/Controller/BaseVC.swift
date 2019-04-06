//
//  BaseVC.swift
//  BaseVC
//
//  Created by Ryan Zander on 1/26/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit
import Reachability

class BaseVC: UIViewController, UITextFieldDelegate {
    
    //var animatedDistance: CGFloat?
    //var keyboardHeight: CGFloat = 0.0
    //var textFieldRect: CGRect?
    //var isKeyboardOpening = false
    
    let reachability = Reachability()!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // detect when the keyboard will change frame
     //   NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowOrHide), name: .UIKeyboardWillChangeFrame, object: nil)
    }

    
    
    
    /*
    @objc func keyboardWillShowOrHide(_ notification: Notification) {
        
        // make sure the keyboard is opening, not closing
        if (isKeyboardOpening) {
        
            // get the keyboard height
            if let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardRect.height
            }
      
            // get the fraction of the keyboard's height that we must slide the view up
            let viewRect: CGRect = self.view.window!.convert(self.view.bounds, from: self.view!)
            let midline: CGFloat = self.textFieldRect!.origin.y + 0.5 * self.textFieldRect!.size.height
            let numerator: CGFloat = midline - viewRect.origin.y - 0.2 * viewRect.size.height
            let denominator: CGFloat = 0.6 * viewRect.size.height
            var heightFraction: CGFloat = numerator / denominator
            if heightFraction < 0.0 {
                heightFraction = 0.0
            }
            else if heightFraction > 1.0 {
                heightFraction = 1.0
            }
            
            // calculate the distance to animate from keyboard height and height fraction
            animatedDistance = floor(keyboardHeight * heightFraction)
      
            // animate self.view above the keyboard
            var viewFrame: CGRect = self.view.frame
            viewFrame.origin.y -= self.animatedDistance!
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.view!.frame = viewFrame
            }, completion: nil)
        }
    }
    */
 
    // dismiss keyboard if user touches the background area
    // in the Storyboard, change the view to UIControl and add TouchUpInside event
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        
       // isKeyboardOpening = false
        self.view.endEditing(true)
    }
    
    
    
    // Dismiss keyboad with Done or Return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       // isKeyboardOpening = false
        textField.resignFirstResponder()
        return true;
    }
    
    /*
    
    // get the textFieldRect for the textField being edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        isKeyboardOpening = true
        self.textFieldRect = self.view.window!.convert(textField.bounds, from: textField)
    }
    
    
    // move the view back down after done with keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y += self.animatedDistance!
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
            self.view!.frame = viewFrame
        }, completion: nil)
    }
 */

    
    // show a basic alert with "OK" to dismiss
    func showAlertWith(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default,  handler: { action in
            // if we had a refresh spinner going, stop it
            self.refreshControl.endRefreshing()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Reachable
    func reachable() -> Bool {
        
        if (reachability.connection != .none) {
            print("we have a connection")
            return true
            
        } else {
            print("not connected")
            return false
        }
    }
    
}
