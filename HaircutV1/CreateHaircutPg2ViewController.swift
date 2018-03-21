//
//  CreateHaircutPg2ViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/13/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import os.log

class CreateHaircutPg2ViewController: UIViewController, UITextViewDelegate {

    // MARK: - Segue Preparation Variables
    var isCreating = true
    var modelController: ModelController!
    var previousVC = ""

    // MARK: - Outlet Variables
    @IBOutlet var descriptionTextField: UITextView!

    // MARK: - Navigation Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "showNextPg3":
            print("STATUS: Preparing Segue to Page 3")

            guard let pg3ViewController = segue.destination as? CreateHaircutPg3ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            print("STATUS: Begin adding to modelController.haircut...")

            modelController.haircut["description"] = descriptionTextField.text
            
            pg3ViewController.modelController = modelController
            pg3ViewController.isCreating = isCreating
            pg3ViewController.previousVC = previousVC

            print("STATUS: Finished adding to modelController.haircut...")
            print("PRINT -> POST - modelController.haircut \(modelController.haircut)")

            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    // MARK: - Keyboard / Touch Functions
    
    // Start Editing The Text Field
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("FUNCTION START: textViewDidBeginEditing")
    }
    
    // Finish Editing The Text Field
    func textViewDidEndEditing(_ textView: UITextView) {
        print("FUNCTION START: textViewDidEndEditing")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this runs whenever the user touches the main area of the app (not the keyboard).
        print("FUNCTION START: touchesBegan")
        self.view.endEditing(true)
    }

    // DEPRECATED: Moves the textview up when user opens keyboard
    /*
     func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
     print("FUNCTION START: moveTextView")
     let moveDuration = 0.3
     let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
     UIView.beginAnimations("animateTextView", context: nil)
     UIView.setAnimationBeginsFromCurrentState(true)
     UIView.setAnimationDuration(moveDuration)
     self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
     UIView.commitAnimations()
     }
     */

    // MARK: - willMove / viewWillAppear / viewDidLoad Functions

    // Called just before the VC is added or removed from a container view controller.

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        print("FUNCTION START: willMove - CreateHaircutPg2ViewController.swift")

        if parent == nil {
            print("STATUS: We're moving FROM p2")
            // The view is being removed from the stack, so call your function here
            modelController.haircut["description"] = descriptionTextField.text
            modelController.haircut = modelController.haircut
            
        } else { print("STATUS: We're moving TO p2")}
    }

    override func viewWillAppear(_ animated: Bool) {
        print("---NEW SCREEN--- FUNCTION START: viewWillAppear - CreateHaircutPg2ViewController.swift")
        // this code is workaround for iOS bug = "iOS UINavigationBar button remains faded after segue back" for "next" button.
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - CreateHaircutPg2ViewController.swift")
        //print("modelController.haircut = \(modelController.haircut)")
        
        // modify textView for description field.
        descriptionTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextField.layer.borderWidth = 1.0;
        descriptionTextField.layer.cornerRadius = 5.0;
        
        refreshView()
        
        // Let's modify page title in navigation bar if we're editing.
        if isCreating == false {
            navigationItem.title = "Editing: Page 2 of 3"
        } else {}
    }

    // MARK: - helper functions
    
    func refreshView() {
        print("FUNCTION START: refreshView()")
        // Let's update existing views if 1. we're editing or 2. we went back to view 1 during creating and then came back.
        // *NOTE: Unlike page 1, we're doing this regardless of if isCreating is false or true because we want to load the haircut here if we go BACK to view 1 and then come back to view 2.
        if modelController.haircut["description"] != nil {
            descriptionTextField.text = modelController.haircut["description"] as? String
        } else {}

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("FUNCTION START: didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
}
