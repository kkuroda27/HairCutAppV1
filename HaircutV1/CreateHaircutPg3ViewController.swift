//
//  CreateHaircutPg3ViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/13/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import CoreData
import os.log

class CreateHaircutPg3ViewController: UIViewController {

    // MARK: - Segue Preparation Variables
    var haircut = PFObject(className: "Haircut")
    var isCreating = true

    @IBAction func saveBtn(_ sender: Any) {
    
        // spinner + disable activity code.
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        // Save in Parse.
        // first, we'll check if we're creating a new haircut, or we're editing an existing one.

        if isCreating == true {

            haircut.saveInBackground { (success, error) in
                print(self.haircut)
                if (success) {
                    print("Save successful")
                    if let ojID = self.haircut.objectId {
                        print(ojID)
                    } else {}
                    self.displayAlert(title: "Haircut Saved!", message: "Your NEW haircut has been saved successfully")
                    
                } else {
                    print("Save failed while saving new object")
                    print(error?.localizedDescription as Any)
                    self.displayAlert(title: "Error!", message: (error?.localizedDescription)!)
                }
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
            }

        } else {
            print("Editing Existing Object!")
            print(haircut)
            if let haircutObjectId = haircut.objectId {
                
                let query = PFQuery(className:"Haircut")
                query.getObjectInBackground(withId: haircutObjectId) {
                    (object, error) -> Void in
                    if error != nil {
                        print("Error!")
                        print(error!)
                    } else if let object = object {
                        print("existing object retrieval success")
                        object["userUUID"] = self.haircut["userUUID"]
                        object["title"] = self.haircut["title"]
                        object["description"] = self.haircut["description"]
                        object["frontImage"] = self.haircut["frontImage"]
                        object["sideImage"] = self.haircut["sideImage"]
                        object["backImage"] = self.haircut["backImage"]
                        
                        // save object to Parse
                        object.saveInBackground { (success, error) in
                            if (success) {
                                print("Save successful")
                                self.displayAlert(title: "Haircut Saved!", message: "Your haircut has been saved successfully")
                                
                            } else {
                                print("Save failed while saving editing object")
                                print(error?.localizedDescription as Any)
                                self.displayAlert(title: "Error!", message: (error?.localizedDescription)!)
                                
                            }
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        
                        
                    }
                }
                
            } else {
                print("Something's wrong")
            }
        }
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("SCREEN THREE!!")
        print(haircut)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - helper functions
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
            // segue transitions
            let isPresentingInAddHaircutMode = self.presentingViewController is UINavigationController
            if isPresentingInAddHaircutMode {
                print("dismiss if flow is CREATE haircut")
                self.dismiss(animated: true, completion: nil)
            
            } else if let owningNavigationController = self.navigationController{
                print("dismiss if flow is EDIT haircut")
                
                let nb = 4
                if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
                    guard viewControllers.count < nb else {
                        owningNavigationController.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                        return
                    }
                }
                //owningNavigationController.popViewController(animated: true)

            } else {
                fatalError("The MealViewController is not inside a navigation controller.")
            }
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    

}
