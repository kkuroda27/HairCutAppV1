//
//  CreateHaircutPg2ViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/13/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import CoreData
import os.log

class CreateHaircutPg2ViewController: UIViewController, UITextViewDelegate {

    // MARK: - Segue Preparation Variables
    var isCreating = true
    var modelController: ModelController!

    // MARK: - Outlets
    @IBOutlet var descriptionTextField: UITextView!

    // MARK: - Keyboard Functions
    
    // Moves the textview up when user opens keyboard
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // Start Editing The Text Field
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textViewDidEndEditing(_ textView: UITextView) {
        moveTextView(textView, moveDistance: -250, up: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this runs whenever the user touches the main area of the app (not the keyboard).
        print("touchesBegan")
        self.view.endEditing(true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "showNextPg3":
            //os_log("Adding a new haircut.", log: OSLog.default, type: .debug)
            print("STATUS: Preparing Segue to Page 3")

            guard let pg3ViewController = segue.destination as? CreateHaircutPg3ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            print("STATUS: Begin adding to modelController.haircut...")

            modelController.haircut["description"] = descriptionTextField.text
            
            pg3ViewController.modelController = modelController
            pg3ViewController.isCreating = isCreating

            print("STATUS: Finished adding to modelController.haircut...")
            print("PRINT -> POST - modelController.haircut \(modelController.haircut)")

            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    // MARK: - willMove

    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        print("FUNCTION START: willMove - to page 1")

        if parent == nil {
            // The view is being removed from the stack, so call your function here
            modelController.haircut["description"] = descriptionTextField.text
            modelController.haircut = modelController.haircut
        }
    }

    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        print("FUNCTION START: viewWillAppear - CreateHaircutPg2ViewController.swift")

        // this code is workaround for iOS bug = "iOS UINavigationBar button remains faded after segue back" for "next" button.
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        print("FUNCTION START: viewDidLoad - CreateHaircutPg2ViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")
        
        // modify textView for description field.
        descriptionTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextField.layer.borderWidth = 1.0;
        descriptionTextField.layer.cornerRadius = 5.0;
        
        // Handle the text field's user input through delegate callbacks.
        descriptionTextField.delegate = self

        // Let's update existing views if 1. we're editing or 2. we went back to another view during creating and then came back.
        if modelController.haircut["description"] == nil {
            // do nothing
        } else {
            descriptionTextField.text = modelController.haircut["description"] as? String
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
