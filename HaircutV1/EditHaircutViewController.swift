//
//  EditHaircutViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/3/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import CoreData
import os.log
import ALCameraViewController

class EditHaircutViewController: UIViewController {

    // MARK: - Segue Preparation Variables
    var modelController: ModelController!

    // MARK: - Outlet Variables
    
    @IBOutlet var haircutNameTextField: UITextField!

    @IBOutlet var imgFront: UIImageView!
    @IBOutlet var imgSide: UIImageView!
    @IBOutlet var imgBack: UIImageView!
    
    @IBOutlet var btnFrontRetake: UIButton!
    @IBOutlet var btnSideRetake: UIButton!
    @IBOutlet var btnBackRetake: UIButton!
    
    @IBOutlet var iconUploadFront: UIImageView!
    @IBOutlet var iconUploadSide: UIImageView!
    @IBOutlet var iconUploadBack: UIImageView!
   
    @IBOutlet var descriptionTextField: UITextView!

    @IBOutlet var stylistNameTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var salonCityTextField: UITextField!
   
    // MARK: - Extra Global Variables
    var imagePicked = 1

    var imgFrontSet = false
    var imgSideSet = false
    var imgBackSet = false

    
    // MARK: - Save Function

    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
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

        // let's update haircut object with new variables.
        modelController.haircut["haircutName"] = haircutNameTextField.text
        
        
        // Now do Pictures... If image exists AND it is NOT placeholder, convert and set to PFObject.
        // let's check if each image is a placeholder, and if so, then hide "retake" button.
        //var imagePH = UIImage()
        
        // if FRONT image exists, convert it and set PFObject
        if let imageData = self.imgFront.image {
            
            if imgFrontSet == false {
                // Front image is not set, aka a placeholder, so do nothing.
            } else {
                // Our image is NOT a placeholder, so let's actually save.
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("ERROR: JPEG Conversion failed")
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
        if let imageData = self.imgSide.image {
            
            if imgSideSet == false {
                // Side image is not set, aka a placeholder, so do nothing.
            } else {
                // Our image is NOT a placeholder, so let's actually save.
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("ERROR: JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageSide.jpg", data: imageDataJPEG)
                modelController.haircut["sideImage"] = imageFile
                
            }
            
        } else {
            print("ERROR: Side image does not exist")
        }
        
        // if BACK image exists, convert it and set PFObject
        if let imageData = self.imgBack.image {
            
            if imgBackSet == false {
                // Back image is not set, aka a placeholder, so do nothing.
            } else {
                // Our image is NOT a placeholder, so let's actually save.
                guard let imageDataJPEG = UIImageJPEGRepresentation(imageData, 0.5) else {
                    print("ERROR: JPEG Conversion failed")
                    return
                }
                let imageFile = PFFile(name: "imageBack.jpg", data: imageDataJPEG)
                modelController.haircut["backImage"] = imageFile
            }
            
        } else {
            print("ERROR: Back image does not exist")
        }

        modelController.haircut["description"] = descriptionTextField.text
        modelController.haircut["stylistName"] = stylistNameTextField.text

        // format date and store.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        if(datePicker == nil){
        } else {
            modelController.haircut["dateSet"] = dateFormatter.string(from: datePicker.date)
        }

        modelController.haircut["salonCity"] = salonCityTextField.text

        print("STATUS: Editing Existing PFObject!")

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
    
    // MARK: - Image Functions

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        print("FUNCTION START: imageTapped")
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        //var imagePH = UIImage()
        var imageSet = Bool()
        // set global variable imagePicked to tag so we can distinguish between images.
        self.imagePicked = (sender.view?.tag)!
        
        switch imagePicked {
        case 2:
            imageSet = self.imgSideSet
        case 3:
            imageSet = self.imgBackSet
        default:
            imageSet = self.imgFrontSet
        }
        
        //if imagePH == imageView.image {
        if imageSet == false {
            
            print("Image hasn't been set yet, so we have the placeholder here.")
            // execute show camera controller
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                print("NOTE: Camera is available!")
                let cameraViewController = CameraViewController { [weak self] image, asset in
                    // Do something with your image here.
                    if let image = image {
                        switch self?.imagePicked {
                        case 2?:
                            self?.imgSide.image = image
                            self?.btnSideRetake.isHidden = false
                            self?.iconUploadSide.isHidden = true
                            self?.imgSideSet = true
                            
                        case 3?:
                            self?.imgBack.image = image
                            self?.btnBackRetake.isHidden = false
                            self?.iconUploadBack.isHidden = true
                            self?.imgBackSet = true
                            
                            
                        default:
                            self?.imgFront.image = image
                            self?.btnFrontRetake.isHidden = false
                            self?.iconUploadFront.isHidden = true
                            self?.imgFrontSet = true
                            
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
            print("NOTE: Camera is available!")
            self.imagePicked = sender.tag
            let cameraViewController = CameraViewController { [weak self] image, asset in
                // Comment from plugin Author: "Do something with your image here."
                if let image = image {
                    switch self?.imagePicked {
                    case 2?:
                        self?.imgSide.image = image
                    case 3?:
                        self?.imgBack.image = image
                    default:
                        self?.imgFront.image = image
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

    // MARK: - viewDidLoad Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - EditHaircutViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")

        // By default, we want "Retake" buttons to be hidden.
        btnFrontRetake.isHidden = true
        btnSideRetake.isHidden = true
        btnBackRetake.isHidden = true
        
        // modify textView for description field.
        descriptionTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionTextField.layer.borderWidth = 1.0;
        descriptionTextField.layer.cornerRadius = 5.0;

        refreshView() // update view with modelController.haircut


    }

    // MARK: - helper functions
    
    func refreshView() {
        print("FUNCTION START: refreshView()")
        
        haircutNameTextField.text = modelController.haircut["haircutName"] as? String
        descriptionTextField.text = modelController.haircut["description"] as? String
        stylistNameTextField.text = modelController.haircut["stylistName"] as? String

        if modelController.haircut["dateSet"] != nil {
            // Convert dateSet string back to date format and set it to Date Picker.
            // format date and store.
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let date = dateFormatter.date(from: modelController.haircut["dateSet"] as! String)
            datePicker.setDate(date!, animated: true)
        } else {}

        salonCityTextField.text = modelController.haircut["salonCity"] as? String

        if modelController.haircut["frontImage"] != nil {
            let tempImage = modelController.haircut["frontImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData) {
                        self.imgFront.image = imageToDisplay
                        self.btnFrontRetake.isHidden = false
                        self.iconUploadFront.isHidden = true
                        self.imgFrontSet = true
                        
                    }
                }
            }
            
        } else {
            print("frontImage doesn't exist!")
        }
        
        if modelController.haircut["sideImage"] != nil {

            let tempImage = modelController.haircut["sideImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData) {
                        self.imgSide.image = imageToDisplay
                        self.btnSideRetake.isHidden = false
                        self.iconUploadSide.isHidden = true
                        self.imgSideSet = true

                    }
                }
            }
        } else {
            print("sideImage doesn't exist!")
            
        }
        
        if modelController.haircut["backImage"] != nil {
            
            let tempImage = modelController.haircut["backImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData) {
                        self.imgBack.image = imageToDisplay
                        self.btnBackRetake.isHidden = false
                        self.iconUploadBack.isHidden = true
                        self.imgBackSet = true


                    }
                }
            }
        } else {
            print("backImage doesn't exist!")
        }
        
    }

    func displayAlert(title:String, message:String) {
        print("FUNCTION START: displayAlert")
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            print("STATUS: Coming from Full Details, aka we're in Edit Haircut Flow")
            //self.dismiss(animated: true, completion: nil)
            
            if let owningNavigationController = self.navigationController {
                owningNavigationController.popViewController(animated: true)
            } else {
                fatalError("The owningNavigationController is not inside a navigation controller.")
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
