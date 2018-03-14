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
    var haircut = PFObject(className: "Haircut")
    var isCreating = true

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
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "showNextPg3":
            os_log("Adding a new haircut.", log: OSLog.default, type: .debug)
            
            print(haircut)
            guard let pg3ViewController = segue.destination as? CreateHaircutPg3ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            // start object editing
            
            print("Adding to New Object!")
            haircut["description"] = descriptionTextField.text
            
            
            // end object creation
            print(haircut)
            pg3ViewController.haircut = haircut
            pg3ViewController.isCreating = isCreating

            
        case "showHelp":
            os_log("Showing help screen", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        // this code is workaround for iOS bug = "iOS UINavigationBar button remains faded after segue back" for "next" button.
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        print("SCREEN TWO!")
        print(haircut)
        // modify textView for description field.
        descriptionTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextField.layer.borderWidth = 1.0;
        descriptionTextField.layer.cornerRadius = 5.0;
        
        // Handle the text field's user input through delegate callbacks.
        descriptionTextField.delegate = self

        if haircut.objectId != nil {
            // We're editing, not creating. let's update view.
            // update title and textField elements.
            //navigationItem.title = haircut["title"] as? String
            descriptionTextField.text = haircut["description"] as? String
            
            
        } else {
            // we're creating a new haircut, so do nothing.
            
        }

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
