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
import ALCameraViewController
class CreateHaircutPg1ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // MARK: - Segue Preparation Variables
    var isCreating = true
    var modelController: ModelController!
    var previousVC = ""

    // MARK: - Outlet Variables
    @IBOutlet var stylistNameTextField: UITextField!
    @IBOutlet var imgLeft: UIImageView!
    @IBOutlet var imgCenter: UIImageView!
    @IBOutlet var imgRight: UIImageView!
    
    @IBOutlet var btnFrontRetake: UIButton!
    @IBOutlet var btnSideRetake: UIButton!
    @IBOutlet var btnBackRetake: UIButton!
    
    @IBOutlet var iconUploadFront: UIImageView!
    @IBOutlet var iconUploadSide: UIImageView!
    @IBOutlet var iconUploadBack: UIImageView!
    
    // MARK: - Extra Global Variables
    var imagePicked = 1
    var userUUID = ""
    
    // MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")

        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "showNextPg2": 
            print("STATUS: Preparing Segue to Page 2")

            guard let pg2ViewController = segue.destination as? CreateHaircutPg2ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            print("STATUS: Begin adding to modelController.haircut...")
            print("PRINT -> PRE - modelController.haircut \(modelController.haircut)")

            if isCreating {
                print("STATUS: isCreating == true")
                // now update fields that don't exist in new object.
                // update userUUID
                modelController.haircut["userUUID"] = userUUID
                
                // Grab created date, convert from date -> String, store in PFObject
                let now = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
                let stringDate: String = dateFormatter.string(from: now as Date)
                modelController.haircut["dateCreated"] = stringDate

            } else {
                print("STATUS: isCreating == false")
            }
            
            modelController.haircut["stylistName"] = stylistNameTextField.text

            // Now do Pictures... If image exists AND it is NOT placeholder, convert and set to PFObject.
            // let's check if each image is a placeholder, and if so, then hide "retake" button.
            var imagePH = UIImage()

            // if FRONT image exists, convert it and set PFObject
            if let imageData = self.imgLeft.image {
                // check for placeholder.
                imagePH = UIImage(named: "frontPlaceholder")!
                if imagePH == self.imgLeft.image {
                    // placeholder, so do nothing.
                } else {
                    // not placeholder, so actually save.
                    //convert
                    guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                        print("JPEG Conversion failed")
                        return
                    }
                    let imageFile = PFFile(name: "imageFront.jpg", data: imageDataJPEG)
                    modelController.haircut["frontImage"] = imageFile
                    
                    // find and print image size, just to know.
                    var imageSize = Float(imageDataJPEG.count)
                    imageSize = imageSize/(1024*1024)
                    print("NOTE: image size for imageFront is \(imageSize)Mb")

                }
                
            } else {
                print("ERROR: Front image does not exist")
            }
            
            // if SIDE image exists, convert it and set PFObject
            if let imageData = self.imgCenter.image {
                // check for placeholder.
                imagePH = UIImage(named: "sidePlaceholder")!
                if imagePH == self.imgCenter.image {
                    // placeholder, so do nothing.
                    
                } else {
                    // not placeholder, so actually save.
                    //convert
                    guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                        print("JPEG Conversion failed")
                        return
                    }
                    let imageFile = PFFile(name: "imageSide.jpg", data: imageDataJPEG)
                    modelController.haircut["sideImage"] = imageFile
                
                }

            } else {
                print("ERROR: Side image does not exist")
            }
            
            // if BACK image exists, convert it and set PFObject
            if let imageData = self.imgRight.image {
                // check for placeholder.
                imagePH = UIImage(named: "backPlaceholder")!
                if imagePH == self.imgRight.image {
                    // placeholder, so do nothing.
                    
                } else {
                    // not placeholder, so actually save.
                    guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                        print("JPEG Conversion failed")
                        return
                    }
                    let imageFile = PFFile(name: "imageBack.jpg", data: imageDataJPEG)
                    modelController.haircut["backImage"] = imageFile
                }

            } else {
                print("ERROR: Back image does not exist")
            }
            
            print("STATUS: Finished adding to modelController.haircut...")
            print("PRINT -> POST - modelController.haircut \(modelController.haircut)")

            
        pg2ViewController.modelController = modelController
        pg2ViewController.isCreating = isCreating

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        print("FUNCTION START: cancel")
        
        // Code and comments here retrieved from "https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementEditAndDeleteBehavior.html#//apple_ref/doc/uid/TP40015214-CH9-SW4"
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        //This code creates a Boolean value that indicates whether the view controller that presented this scene is of type UINavigationController. As the constant name isPresentingInAddHaircutMode indicates, this means that the meal detail scene is presented by the user tapping the Add button. This is because the meal detail scene is embedded in its own navigation controller when it’s presented in this manner, which means that the navigation controller is what presents it.
        
        if previousVC == "FullDetailsModeViewController" {
            print("Coming from Full Details")
            if let owningNavigationController = navigationController {
                owningNavigationController.popViewController(animated: true)
            } else {
                fatalError("The MealViewController is not inside a navigation controller.")
            }

        } else if previousVC == "ViewMyHaircutsController" {
            print("Coming from ViewMyHaircutsController")
            dismiss(animated: true, completion: nil)

        } else {
            print("this should never happen")
        }
        
        dismiss(animated: true, completion: nil)

        /* // DEPRECATED CANCEL BUTTON HANDLER
        // if this is true, then the view controller was presented by clicking the "Add" button.
        if isPresentingInAddHaircutMode {
            // takes you back to myhaircutstable
            dismiss(animated: true, completion: nil)
            
            // The else block (below) is called if the user is editing an existing haircut. This also means that the haircut detail scene was pushed onto a navigation stack when the user selected a haircut from the haircut list. The else statement uses an if let statement to safely unwrap the view controller’s navigationController property. If the view controller has been pushed onto a navigation stack, this property contains a reference to the stack’s navigation controller.

        } else if let owningNavigationController = navigationController{
            // takes you back to previous screen.
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
        dismiss(animated: true, completion: nil)
        */
    }

    
    // MARK: - Keyboard / Touch Functions
    
    // this runs when return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("FUNCTION START: textFieldShouldReturn")
        textField.resignFirstResponder() // shut down the keyboard associated with the textField being edited.
        return true
    }
    
    // this runs whenever the user touches the main area of the app (not the keyboard).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("FUNCTION START: touchesBegan")
        self.view.endEditing(true)
    }
    
    // MARK: - Image Functions

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        print("FUNCTION START: imageTapped")

        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        
        var imagePH = UIImage()
        // set global variable imagePicked to tag so we can distinguish between images.
        self.imagePicked = (sender.view?.tag)!
        
        switch imagePicked {
        case 2:
            imagePH = UIImage(named: "sidePlaceholder")!
        case 3:
            imagePH = UIImage(named: "backPlaceholder")!
        default:
            imagePH = UIImage(named: "frontPlaceholder")!
        }

        if imagePH == imageView.image {
            print("Image DOES equal placeholder... So present camera view")
            // execute show camera controller
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                print("Camera is available!")
                let cameraViewController = CameraViewController { [weak self] image, asset in
                    // Do something with your image here.
                    if let image = image {
                        switch self?.imagePicked {
                        case 2?:
                            self?.imgCenter.image = image
                            self?.btnSideRetake.isHidden = false
                            self?.iconUploadSide.isHidden = true


                        case 3?:
                            self?.imgRight.image = image
                            self?.btnBackRetake.isHidden = false
                            self?.iconUploadBack.isHidden = true

                        default:
                            self?.imgLeft.image = image
                            self?.btnFrontRetake.isHidden = false
                            self?.iconUploadFront.isHidden = true
                        }

                    } else {
                        print("There was a problem getting the image")
                    }
                    self?.dismiss(animated: true, completion: nil)
                }
                
                present(cameraViewController, animated: true, completion: nil)
                
                
            } else {
                print("Camera is NOT available!")
                let alert2 = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIKit.UIAlertAction(title: "OK", style: .default, handler:{ (UIAlertAction)in
                    print("Alert Displayed")
                }))
                self.present(alert2, animated: true, completion: nil)
            }

        } else {
            print("Image DOES NOT equal placeholder... So present full image view.")
            // execute view image full
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
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        print("FUNCTION START: dismissFullscreenImage")
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    // Currently linked to all "retake" buttons.
    @IBAction func retakePhoto(_ sender: UIButton) {
    print("FUNCTION START: retakePhoto")

    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            print("Camera is available!")
            self.imagePicked = sender.tag
            let cameraViewController = CameraViewController { [weak self] image, asset in
                // Comment from plugin Author: "Do something with your image here."
                if let image = image {
                    switch self?.imagePicked {
                    case 2?:
                        self?.imgCenter.image = image
                    case 3?:
                        self?.imgRight.image = image
                    default:
                        self?.imgLeft.image = image
                    }
                    
                } else {
                    print("There was a problem getting the image")
                }
                
                self?.dismiss(animated: true, completion: nil)
            }
            
            present(cameraViewController, animated: true, completion: nil)
        
        } else {
            print("NOTE: Camera is NOT available!")
            let alert2 = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: UIAlertControllerStyle.alert)
            alert2.addAction(UIKit.UIAlertAction(title: "OK", style: .default, handler:{ (UIAlertAction)in
                print("Alert Displayed")
            }))
            self.present(alert2, animated: true, completion: nil)
        }
    }

    // MARK: - viewWillAppear / viewDidLoad Functions

    override func viewWillAppear(_ animated: Bool) {
        print("---NEW SCREEN--- FUNCTION START: viewWillAppear - CreateHaircutPg1ViewController.swift")
        // this code is workaround for iOS bug = "iOS UINavigationBar button remains faded after segue back" for "next" button.
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - CreateHaircutPg1ViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")
        
        // By default, we want "Retake" button to be hidden.
        btnFrontRetake.isHidden = true
        btnSideRetake.isHidden = true
        btnBackRetake.isHidden = true

        iconUploadFront.isHidden = false
        iconUploadSide.isHidden = false
        iconUploadBack.isHidden = false

        // Handle the text field's user input through delegate callbacks.
        stylistNameTextField.delegate = self
        

        // set up views if editing an existing Haircut.
        if modelController.haircut.objectId != nil {
            isCreating = false
            // We're editing, not creating. let's update view.
            // update title and textField elements.
            navigationItem.title = modelController.haircut["haircutName"] as? String
            stylistNameTextField.text = modelController.haircut["stylistName"] as? String

            if modelController.haircut["frontImage"] != nil {
                btnFrontRetake.isHidden = false
                iconUploadFront.isHidden = true
                let tempImage = modelController.haircut["frontImage"] as! PFFile
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
            
            if modelController.haircut["sideImage"] != nil {
                btnSideRetake.isHidden = false
                iconUploadSide.isHidden = true

                let tempImage = modelController.haircut["sideImage"] as! PFFile
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
            
            if modelController.haircut["backImage"] != nil {
                btnBackRetake.isHidden = false
                iconUploadBack.isHidden = true

                let tempImage = modelController.haircut["backImage"] as! PFFile
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
        print("FUNCTION START: displayAlert")

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
        print("FUNCTION START: didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }

    
    /*
     // Deprecated function to allow users to select Camera or Upload.
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
     */
    
    /*
     
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
     */
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

    
}

