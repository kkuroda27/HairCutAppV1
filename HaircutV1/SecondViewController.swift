//
//  SecondViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 1/29/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import CoreData

class SecondViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // for segue preparation
    var haircut = PFObject(className: "Haircut")
    var isCreating = true
    
    // MARK: Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imgLeft: UIImageView!
    @IBOutlet var imgCenter: UIImageView!
    @IBOutlet var imgRight: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Code and comments here retrieved from "https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementEditAndDeleteBehavior.html#//apple_ref/doc/uid/TP40015214-CH9-SW4"
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        //This code creates a Boolean value that indicates whether the view controller that presented this scene is of type UINavigationController. As the constant name isPresentingInAddHaircutMode indicates, this means that the meal detail scene is presented by the user tapping the Add button. This is because the meal detail scene is embedded in its own navigation controller when it’s presented in this manner, which means that the navigation controller is what presents it.

        let isPresentingInAddHaircutMode = presentingViewController is UINavigationController
        
        // if this is true, then the view controller was presented by clicking the "Add" button.
        if isPresentingInAddHaircutMode {
            dismiss(animated: true, completion: nil)
            
            // The else block (below) is called if the user is editing an existing haircut. This also means that the haircut detail scene was pushed onto a navigation stack when the user selected a haircut from the haircut list. The else statement uses an if let statement to safely unwrap the view controller’s navigationController property. If the view controller has been pushed onto a navigation stack, this property contains a reference to the stack’s navigation controller.
            
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }


        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Extra Variables
    var imagePicked = 1
    var userUUID = ""

    // MARK: User Interactions
    @IBAction func chooseImg(_ sender: UIButton) {
        // the sender.tag will be passed to imagePickerController to change the correct imageView.
        imagePicked = sender.tag
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        

        // first, we'll check if we're creating a new haircut, or we're editing an existing one.
        if isCreating == true {
            // now let's create Parse Object that we'd like to save.
            let haircutObject = PFObject(className: "Haircut")

            print("Creating New Object!")
            haircutObject["userUUID"] = userUUID
            haircutObject["title"] = titleTextField.text
            haircutObject["description"] = descriptionTextField.text
            
            // if FRONT image exists, convert it and set PFObject
            if let imageData = imgLeft.image {
                guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                    print("PNG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageFront.png", data: imageDataPNG)
                haircutObject["frontImage"] = imageFile
            } else {
                print("Front image does not exist")
            }
            
            // if SIDE image exists, convert it and set PFObject
            if let imageData = imgCenter.image {
                guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                    print("PNG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageSide.png", data: imageDataPNG)
                haircutObject["sideImage"] = imageFile
            } else {
                print("Side image does not exist")
            }
            
            // if BACK image exists, convert it and set PFObject
            if let imageData = imgRight.image {
                guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                    print("PNG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageBack.png", data: imageDataPNG)
                haircutObject["backImage"] = imageFile
            } else {
                print("Back image does not exist")
            }
            
            // Save in Parse.
            haircutObject.saveInBackground { (success, error) in
                if (success) {
                    print("Save successful")
                    if let ojID = haircutObject.objectId {
                        print(ojID)
                    }
                } else {
                    print("Save failed")
                }
            }

        } else {
            print("Editing Existing Object!")
            if let haircutObjectId = haircut.objectId {
                
                 let query = PFQuery(className:"Haircut")
                 query.getObjectInBackground(withId: haircutObjectId) {
                 (object, error) -> Void in
                     if error != nil {
                        print("Error!")
                        print(error!)
                     } else if let object = object {
                        print("existing object retrieval success")

                        object["userUUID"] = self.userUUID
                        object["title"] = self.titleTextField.text
                        object["description"] = self.descriptionTextField.text
                        
                        // if FRONT image exists, convert it and set PFObject
                        if let imageData = self.imgLeft.image {
                            guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                                print("PNG Conversion failed")
                                return
                            }
                            let imageFile = PFFile(name: "imageFront.png", data: imageDataPNG)
                            object["frontImage"] = imageFile
                        } else {
                            print("Front image does not exist")
                        }
                        
                        // if SIDE image exists, convert it and set PFObject
                        if let imageData = self.imgCenter.image {
                            guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                                print("PNG Conversion failed")
                                return
                            }
                            let imageFile = PFFile(name: "imageSide.png", data: imageDataPNG)
                            object["sideImage"] = imageFile
                        } else {
                            print("Side image does not exist")
                        }
                        
                        // if BACK image exists, convert it and set PFObject
                        if let imageData = self.imgRight.image {
                            guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                                print("PNG Conversion failed")
                                return
                            }
                            let imageFile = PFFile(name: "imageBack.png", data: imageDataPNG)
                            object["backImage"] = imageFile
                        } else {
                            print("Back image does not exist")
                        }

                        
                        object.saveInBackground { (success, error) in
                            if (success) {
                                print("Save successful")
                                self.displayAlert(title: "Haircut Saved!", message: "Your haircut has been saved successfully")

                            } else {
                                print("Save failed")
                            }
                        }
                     }
                 }
                

                
                
            } else {
                print("Something's wrong")
            }
        }

       
 
    }
 
    // MARK: Image Pickers

   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            switch imagePicked {
            case 2:
                imgCenter.image = image
            case 3:
                imgRight.image = image
            default:
                imgLeft.image = image
            }

        } else {
            print("There was a problem getting the image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Handle the text field's user input through delegate callbacks.
        titleTextField.delegate = self as? UITextFieldDelegate
        
        // set up views if editing an existing Haircut.
        if haircut.objectId != nil {
            isCreating = false
            // We're editing, not creating. let's update view.
            // update title and textField elements.
            navigationItem.title = haircut["title"] as? String
            titleTextField.text = haircut["title"] as? String
            descriptionTextField.text = haircut["description"] as? String

            if haircut["frontImage"] != nil {
                let tempImage = haircut["frontImage"] as! PFFile
                tempImage.getDataInBackground { (data, error) in
                    if let imageData = data {
                        if let imageToDisplay = UIImage(data: imageData) {
                            self.imgLeft.image = imageToDisplay
                        }
                    }
                }
            } else {
                print("frontImage doesn't exist!")
            }
            
            if haircut["sideImage"] != nil {
                let tempImage = haircut["sideImage"] as! PFFile
                tempImage.getDataInBackground { (data, error) in
                    if let imageData = data {
                        if let imageToDisplay = UIImage(data: imageData) {
                            self.imgCenter.image = imageToDisplay
                        }
                    }
                }
            } else {
                print("sideImage doesn't exist!")
            }
            
            if haircut["backImage"] != nil {
                let tempImage = haircut["backImage"] as! PFFile
                tempImage.getDataInBackground { (data, error) in
                    if let imageData = data {
                        if let imageToDisplay = UIImage(data: imageData) {
                            self.imgRight.image = imageToDisplay
                        }
                    }
                }
            } else {
                print("backImage doesn't exist!")
            }
            
        } else {
            // we're creating a new haircut, so do nothing.
            isCreating = true

        }
        
        // enable the save button only if the text field has a valid meal name.
        // updateSaveButtonState()
        
        // coreData delegates
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext // we can use context to access CoreData
        
        // core data retrieval
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserRecords")
        request.returnsObjectsAsFaults = false // by default, when request is run, instead of returning actual data, it'll return faults. we usually want this set to false.
        
        do { // this person is an existing user... let's just retrieve the stored userUUID.
            
            let results = try context.fetch(request)
            if results.count > 0 {
                // we already have a UserRecord
                for result in results as! [NSManagedObject] {
                    print("User Record found!")
                    print(result)
                    if let userID = result.value(forKey: "userID") as? String {
                        userUUID = userID
                    }
                }
                
            } else { // something went very wrong... This should never happen because if a user hits FirstViewController, they should have a stored userUUID...
                print("Something terrible has happened.")
            }
            
        } catch {
            print("Couldn't fetch results")
        }
        

    }
    
    // MARK: helper functions
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

