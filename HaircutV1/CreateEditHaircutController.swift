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
import os.log

class CreateEditHaircutController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    // MARK: - Segue Preparation Variables
    var haircut = PFObject(className: "Haircut")
    var isCreating = true
    
    // MARK: - Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imgLeft: UIImageView!
    @IBOutlet var imgCenter: UIImageView!
    @IBOutlet var imgRight: UIImageView!
    @IBOutlet var descriptionTextField: UITextView!
    
    // MARK: - Extra Variables
    var imagePicked = 1
    var userUUID = ""
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "showNextPg2": 
            os_log("Adding a new haircut.", log: OSLog.default, type: .debug)
            
            print(haircut)
            guard let pg2ViewController = segue.destination as? CreateHaircutPg2ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            // start object creation

            // now let's create Parse Object that we'd like to save.
            let haircutObject = PFObject(className: "Haircut")
            
            print("Creating New Object!")
            haircutObject["userUUID"] = userUUID
            haircutObject["title"] = titleTextField.text
            haircutObject["description"] = descriptionTextField.text
            
            // convert from date -> String
            let now = NSDate()
            print("nowDate = ")
            print(now)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            let stringDate: String = dateFormatter.string(from: now as Date)
            
            haircutObject["dateCreated"] = stringDate
            
            // if FRONT image exists, convert it and set PFObject
            if let imageData = self.imgLeft.image {
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageFront.jpg", data: imageDataJPEG)
                haircutObject["frontImage"] = imageFile
                
                var imageSize = Float(imageDataJPEG.count)
                imageSize = imageSize/(1024*1024)
                print("image size is \(imageSize)Mb")
            } else {
                print("Front image does not exist")
            }
            
            // if SIDE image exists, convert it and set PFObject
            if let imageData = self.imgCenter.image {
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageSide.jpg", data: imageDataJPEG)
                haircutObject["sideImage"] = imageFile
            } else {
                print("Side image does not exist")
            }
            
            // if BACK image exists, convert it and set PFObject
            if let imageData = self.imgRight.image {
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageBack.jpg", data: imageDataJPEG)
                haircutObject["backImage"] = imageFile
            } else {
                print("Back image does not exist")
            }
            
            // end object creation
            haircut = haircutObject
            print(haircut)
            pg2ViewController.haircut = haircut
            
        case "showHelp":
            os_log("Showing help screen", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    
    // MARK: - User Interactions? (Save + Cancel)
    @IBAction func saveBtn(_ sender: Any) {
        
        // spinner + disable activity code.
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // first, we'll check if we're creating a new haircut, or we're editing an existing one.
        if isCreating == true {
            // now let's create Parse Object that we'd like to save.
            let haircutObject = PFObject(className: "Haircut")
            
            print("Creating New Object!")
            haircutObject["userUUID"] = userUUID
            haircutObject["title"] = titleTextField.text
            haircutObject["description"] = descriptionTextField.text
            
            // convert from date -> String
            let now = NSDate()
            print("nowDate = ")
            print(now)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            let stringDate: String = dateFormatter.string(from: now as Date)
            
            haircutObject["dateCreated"] = stringDate
            
            // if FRONT image exists, convert it and set PFObject
            if let imageData = self.imgLeft.image {
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageFront.jpg", data: imageDataJPEG)
                haircutObject["frontImage"] = imageFile
                
                var imageSize = Float(imageDataJPEG.count)
                imageSize = imageSize/(1024*1024)
                print("image size is \(imageSize)Mb")
            } else {
                print("Front image does not exist")
            }
            
            // if SIDE image exists, convert it and set PFObject
            if let imageData = self.imgCenter.image {
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageSide.jpg", data: imageDataJPEG)
                haircutObject["sideImage"] = imageFile
            } else {
                print("Side image does not exist")
            }
            
            // if BACK image exists, convert it and set PFObject
            if let imageData = self.imgRight.image {
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageBack.jpg", data: imageDataJPEG)
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
                            guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                                print("JPEG Conversion failed")
                                return
                            }
                            let imageFile = PFFile(name: "imageFront.jpg", data: imageDataJPEG)
                            object["frontImage"] = imageFile
                            
                            var imageSize = Float(imageDataJPEG.count)
                            imageSize = imageSize/(1024*1024)
                            print("image size is \(imageSize)Mb")
                        } else {
                            print("Front image does not exist")
                        }
                        
                        // if SIDE image exists, convert it and set PFObject
                        if let imageData = self.imgCenter.image {
                            guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                                print("JPEG Conversion failed")
                                return
                            }
                            let imageFile = PFFile(name: "imageSide.jpg", data: imageDataJPEG)
                            object["sideImage"] = imageFile
                        } else {
                            print("Side image does not exist")
                        }
                        
                        // if BACK image exists, convert it and set PFObject
                        if let imageData = self.imgRight.image {
                            guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                                print("JPEG Conversion failed")
                                return
                            }
                            let imageFile = PFFile(name: "imageBack.jpg", data: imageDataJPEG)
                            object["backImage"] = imageFile
                        } else {
                            print("Back image does not exist")
                        }
                        
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
    
    // Hide the keyboard when the return key pressed

    /*
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("shouldChangeTextIn")
        if(text == "\n"){
            //textView.resignFirstResponder()
            print("return was pressed")
            return false
        }
        return true
    }
    */
    
    // runs when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")

        textField.resignFirstResponder() // shut down the keyboard associated with the textField being edited.
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this runs whenever the user touches the main area of the app (not the keyboard).
        print("touchesBegan")
        self.view.endEditing(true)
    }
    
    // MARK: - ImageView Functions

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        
        newImageView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleWidth]
        
        newImageView.contentMode = UIViewContentMode.scaleAspectFit
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        //newImageView.contentMode = .scaleToFill
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    // MARK: - Image Picker Functions
    @IBAction func chooseImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Please Select an Option to Add Image", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User clicks Camera Button")
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                print("camera is available!")
                self.imagePicked = sender.tag
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                imagePickerController.allowsEditing = false
                
                self.present(imagePickerController, animated: true, completion: nil)
                
            } else {
                print("camera is NOT available!")
                let alert2 = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIKit.UIAlertAction(title: "OK", style: .default, handler:{ (UIAlertAction)in
                    print("Alert Displayed")
                }))
                self.present(alert2, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User clicks Photo Gallery Button")
            self.imagePicked = sender.tag
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = false
            
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User clicks Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        
    }

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
        // Do any additional setup after loading the view, typically from a nib.
        

        descriptionTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextField.layer.borderWidth = 1.0;
        descriptionTextField.layer.cornerRadius = 5.0;
        
        // Handle the text field's user input through delegate callbacks.
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        
        
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
    
    // MARK: - helper functions
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
            // segue transitions
            let isPresentingInAddHaircutMode = self.presentingViewController is UINavigationController
            if isPresentingInAddHaircutMode {
                self.dismiss(animated: true, completion: nil)
            } else if let owningNavigationController = self.navigationController{
                owningNavigationController.popViewController(animated: true)
            } else {
                fatalError("The MealViewController is not inside a navigation controller.")
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

