//
//  CreateHaircutPg3ViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/13/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import os.log

class CreateHaircutPg3ViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Segue Preparation Variables
    var isCreating = true
    var modelController: ModelController!
    var previousVC = ""

    // MARK: - Outlet Variables
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var salonCityTextField: UITextField!
    @IBOutlet var haircutNameTextField: UITextField!
    
    // MARK: - User Interaction Functions (Save)

    @IBAction func saveBtn(_ sender: Any) {
        print("FUNCTION START: saveBtn")

        // spinner + disable activity code.
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        // Before we save, let's update the haircut object with the variables on Screen 3, before we update an existing object OR create a new one.
        modelController.haircut["salonCity"] = salonCityTextField.text
        modelController.haircut["haircutName"] = haircutNameTextField.text
        
        // format date and store.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        if(datePicker == nil){
        } else {
            modelController.haircut["dateSet"] = dateFormatter.string(from: datePicker.date)
        }


        // Save or Update in Parse.
        // Let's check if we're creating a new haircut, or we're editing an existing one.
        
        if isCreating == true {
            print("STATUS: Saving New PFObject!")

            modelController.haircut.saveInBackground { (success, error) in
                if (success) {
                    print("STATUS: New Object Save successful")
                    if let ojID = self.modelController.haircut.objectId {
                        print(ojID)
                    } else {}
                    self.displayAlert(title: "Haircut Saved!", message: "Your NEW haircut has been saved successfully")
                    
                } else {
                    print("STATUS: New Object Save UNsuccessful")
                    print("ERROR: \(error?.localizedDescription as Any)")
                    self.displayAlert(title: "Error!", message: (error?.localizedDescription)!)
                }
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
            }

        } else {
            print("STATUS: Editing Existing PFObject!")
            if let haircutObjectId = modelController.haircut.objectId {
                
                let query = PFQuery(className:"Haircut")
                query.getObjectInBackground(withId: haircutObjectId) {
                    (object, error) -> Void in
                    if error != nil {
                        print("STATUS: Existing Object retrieval UNsuccessful")
                        print("ERROR: \(error!)")
                    } else if let object = object {
                        print("STATUS: Existing PFObject retrieval successful")
                        print("STATUS: Updating fields in existing PFObject.")
                        
                        // Fields from Screen 1
                        object["userUUID"] = self.modelController.haircut["userUUID"]
                        object["stylistName"] = self.modelController.haircut["stylistName"]
                       
                        if let tempImage = self.modelController.haircut["frontImage"] {
                            object["frontImage"] = tempImage
                        } else {}
                        if let tempImage = self.modelController.haircut["sideImage"] {
                            object["sideImage"] = tempImage
                        } else {}
                        if let tempImage = self.modelController.haircut["backImage"] {
                            object["backImage"] = tempImage
                        } else {}

                        // Fields from Screen 2
                        object["description"] = self.modelController.haircut["description"]
                        
                        // Fields from Screen 3
                        object["salonCity"] = self.modelController.haircut["salonCity"]
                        object["haircutName"] = self.modelController.haircut["haircutName"]
                        object["dateSet"] = self.modelController.haircut["dateSet"]

                        print("STATUS: Updated existing PFObject, now commencing save on Parse Server")

                        object.saveInBackground { (success, error) in
                            if (success) {
                                print("STATUS: Updating existing PFObject succcessful!")
                                self.displayAlert(title: "Haircut Saved!", message: "Your haircut has been saved successfully")
                                
                            } else {
                                print("STATUS: Updating existing PFObject UNsucccessful!")
                                print("ERROR: \(error?.localizedDescription as Any)")
                                self.displayAlert(title: "Error!", message: (error?.localizedDescription)!)
                                
                            }
                            // resume ignored interactions and remove spinner.
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                }
                
            } else {
                print("ERROR: [if let haircutObjectId = modelController.haircut.objectId] FAILED")
            }
        }
    
    }
    
    // MARK: - Keyboard / Touch Functions
    
    // this runs whenever the user touches the main area of the app (not the keyboard).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("FUNCTION START: touchesBegan")
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("FUNCTION START: textFieldDidBeginEditing - EditHaircutViewController.swift")
        textField.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        textField.layer.borderWidth = 1.0
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("FUNCTION START: textFieldDidEndEditing - EditHaircutViewController.swift")
        textField.layer.borderColor = hexStringToUIColor(hex: "#CDCDCD").cgColor
        //textField.layer.borderWidth = 1.0
        
    }

    
    // MARK: - willMove + viewDidLoad Functions
    
    // Called just before the VC is added or removed from a container view controller.
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        print("FUNCTION START: willMove - CreateHaircutPg3ViewController.swift")

        // If parent == nil, then we're going from p3 -> p2. Otherwise, it's p2 -> p3
        if parent == nil {
            print("STATUS: We're moving FROM p3")
            // The view is being removed from the stack, so call your function here
            modelController.haircut["salonCity"] = salonCityTextField.text
            modelController.haircut["haircutName"] = haircutNameTextField.text
            
            // format date and store.
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            if(datePicker == nil){
            } else {
                modelController.haircut["dateSet"] = dateFormatter.string(from: datePicker.date)
            }

            modelController.haircut = modelController.haircut

        } else { print("STATUS: We're moving TO p3")}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - CreateHaircutPg3ViewController.swift")
        //print("modelController.haircut = \(modelController.haircut)")
        
        salonCityTextField.delegate = self
        haircutNameTextField.delegate = self

        //self.title = "Your TiTle Text"
        let tlabel = UILabel()
        tlabel.text = "Create Haircut | 3 of 3"
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Avenir-Heavy", size: 18)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center;
        self.navigationItem.titleView = tlabel

        refreshView()

        // Let's modify page title in navigation bar if we're editing.
        if isCreating == false {
            navigationItem.title = "Editing: Page 3 of 3"
        } else {}

    }
    
    // MARK: - helper functions
    
    func refreshView() {
        print("FUNCTION START: refreshView()")
        // Let's update existing views if 1. we're editing or 2. we went back to another view during creating and then came back.
        
        if modelController.haircut["salonCity"] != nil {
            salonCityTextField.text = modelController.haircut["salonCity"] as? String
        } else {}
        
        // print("STATUS: Set haircut title to Haircut: $date ONLY IF haircutname doesn't exist. ")
        if modelController.haircut["haircutName"] != nil {
            haircutNameTextField.text = modelController.haircut["haircutName"] as? String
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            var dateString = "Haircut: Date"
            if(datePicker == nil){
            } else {
                dateString = dateFormatter.string(from: datePicker.date)
            }
            haircutNameTextField.text = "Haircut: \(String(describing: dateString))"
        }
        
        if modelController.haircut["dateSet"] != nil {
            // Convert dateSet string back to date format and set it to Date Picker.
            // format date and store.
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let date = dateFormatter.date(from: modelController.haircut["dateSet"] as! String)
            datePicker.setDate(date!, animated: true)
        } else {}

    }

    func displayAlert(title:String, message:String) {
        print("FUNCTION START: displayAlert")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            if self.previousVC == "FullDetailsModeViewController" {
                print("STATUS: Coming from Full Details, aka we're in Edit Haircut Flow")
                if let owningNavigationController = self.navigationController {
                    let nb = 4
                    if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
                        guard viewControllers.count < nb else {
                            owningNavigationController.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                            return
                        }
                    }
                } else {
                    fatalError("The owningNavigationController is not inside a navigation controller.")
                }
                
            } else if self.previousVC == "ViewMyHaircutsController" {
                print("STATUS: Coming from ViewMyHaircutsController, aka we're in Add Haircut Flow")
                self.dismiss(animated: true, completion: nil)
                
            } else {
                print("this should never happen")
            }
            
            self.dismiss(animated: true, completion: nil)

        }))
        
        self.present(alert, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
