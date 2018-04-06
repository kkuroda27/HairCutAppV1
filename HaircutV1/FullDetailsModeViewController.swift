//
//  FullDetailsModeViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/19/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Parse

class FullDetailsModeViewController: UIViewController {

    // MARK: - Segue Preparation Variables
    var modelController: ModelController!
    
    // MARK: - Outlets + Variables
    @IBOutlet var haircutNameLabel: UILabel!
    @IBOutlet var stylistNameLabel: UILabel!
    
    @IBOutlet var imgFront: UIImageView!
    @IBOutlet var imgSide: UIImageView!
    @IBOutlet var imgBack: UIImageView!
    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var haircutDateLabel: UILabel!
    @IBOutlet var salonCityLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    // MARK: - Extra Global Variables
    var imagePicked = 1
    var images = [SKPhoto]()

    // MARK: - Image Tapped Function

    @IBAction func imgTapped(_ sender: UITapGestureRecognizer) {
        print("FUNCTION START: imgTapped")
        
        // set global variable imagePicked to tag so we can distinguish between images.
        self.imagePicked = (sender.view?.tag)!
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(self.imagePicked - 1)
        present(browser, animated: true, completion: {})
        
    }

    // MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "showEdit":
            print("STATUS: Preparing Segue to Edit Mode")
            
            guard let editModeVC = segue.destination as? EditHaircutViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            editModeVC.modelController = modelController
            //editModeVC.previousVC = "FullDetailsModeViewController"
            //editModeVC.isCreating = false

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    // MARK: - Helper Functions

    func refreshView() {
        print("FUNCTION START: refreshView()")
        if modelController.haircut["haircutName"] as? String != "" {
            haircutNameLabel.text = modelController.haircut["haircutName"] as? String
        } else {}

        if modelController.haircut["stylistName"] as? String != "" {
            stylistNameLabel.text = modelController.haircut["stylistName"] as? String
        } else {}
        
        // initialize imageArray with placeholders first.
        self.images.append(SKPhoto.photoWithImage(imgFront.image!))
        self.images.append(SKPhoto.photoWithImage(imgSide.image!))
        self.images.append(SKPhoto.photoWithImage(imgBack.image!))
        
        if modelController.haircut["frontImage"] != nil {
            let tempImage = modelController.haircut["frontImage"] as! PFFile
            tempImage.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData) {
                        self.imgFront.image = imageToDisplay
                        
                        let photo = SKPhoto.photoWithImage(self.imgFront.image!)
                        photo.caption = "Front"
                        self.images[0] = photo
                        print("Front Added!")
                        
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
                        
                        let photo = SKPhoto.photoWithImage(self.imgSide.image!)
                        photo.caption = "Side"
                        self.images[1] = photo
                        print("Side Added!")
                        
                        
                        
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
                        
                        let photo = SKPhoto.photoWithImage(self.imgBack.image!)
                        photo.caption = "Back"
                        self.images[2] = photo
                        print("Back Added!")
                        
                        
                    }
                }
            }
        } else {
            print("backImage doesn't exist!")
        }
        
        descriptionTextView.text = modelController.haircut["description"] as? String
        
        

        haircutDateLabel.text = modelController.haircut["dateSet"] as? String
        
        if modelController.haircut["salonCity"] as? String != "" {
            salonCityLabel.text = modelController.haircut["salonCity"] as? String
        } else {}

    }
    
    // MARK: - viewDidAppear / viewDidLoad Functions
    override func viewWillAppear(_ animated: Bool) {
        print("---NEW SCREEN--- FUNCTION START: viewWillAppear - FullDetailsModeViewController.swift")
        refreshView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("FUNCTION START: viewDidAppear - FullDetailsModeViewController.swift")
        self.scrollView.flashScrollIndicators()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - FullDetailsModeViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")
        refreshView()

        // modify textView for description field.
        //descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        //descriptionTextView.layer.borderWidth = 1.0;
        //descriptionTextView.layer.cornerRadius = 5.0;
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
