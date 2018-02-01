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

    // MARK: Outlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var imgLeft: UIImageView!
    @IBOutlet var imgCenter: UIImageView!
    @IBOutlet var imgRight: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
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
        
        // now let's create Parse Object that we'd like to save.
        let haircut = PFObject(className: "Haircut")
        haircut["userUUID"] = userUUID
        haircut["title"] = titleTextField.text
        haircut["description"] = descriptionTextField.text
        
        // if FRONT image exists, convert it and set PFObject
        if let imageData = imgLeft.image {
            guard let imageDataPNG = UIImagePNGRepresentation(imageData) else {
                print("PNG Conversion failed")
                return
            }
            let imageFile = PFFile(name: "imageFront.png", data: imageDataPNG)
            haircut["frontImage"] = imageFile
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
            haircut["sideImage"] = imageFile
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
            haircut["backImage"] = imageFile
        } else {
            print("Back image does not exist")
        }
        
        // Save in Parse.
        haircut.saveInBackground { (success, error) in
            if (success) {
                print("Save successful")
                if let ojID = haircut.objectId {
                    print(ojID)
                }
            } else {
                print("Save failed")
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                    
                    print(result)
                    if let userID = result.value(forKey: "userID") as? String {
                        print(userID)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

