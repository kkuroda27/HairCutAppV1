//
//  PresentModeViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/19/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse
import SKPhotoBrowser

class PresentModeViewController: UIViewController, UITextViewDelegate {

    // MARK: - Segue Preparation Variables
    var modelController: ModelController!

    // MARK: - Outlets + Variables
    @IBOutlet var imgFront: UIImageView!
    @IBOutlet var imgSide: UIImageView!
    @IBOutlet var imgBack: UIImageView!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    // MARK: - Extra Global Variables
    var imagePicked = 1

    // 1. create SKPhoto Array from UIImage
    var images = [SKPhoto]()


    // This makes sure that the textview content starts at the top of the content.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }

    // MARK: - viewDidLoad Function

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - PresentModeViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")


        // modify textView for description field.
        //descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        //descriptionTextView.layer.borderWidth = 1.0;
        //descriptionTextView.layer.cornerRadius = 5.0;

        descriptionTextView.text = modelController.haircut["description"] as? String
        
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
                        
                        let photo = SKPhoto.photoWithImage(self.imgFront.image!) // add some UIImage
                        photo.caption = "Front"
                        //self.images.append(photo)
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
                        
                        let photo = SKPhoto.photoWithImage(self.imgSide.image!) // add some UIImage
                        photo.caption = "Side"
                        //self.images.append(photo)
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
                        
                        let photo = SKPhoto.photoWithImage(self.imgBack.image!) // add some UIImage
                        photo.caption = "Back"
                        //self.images.append(photo)
                        self.images[2] = photo
                        print("Back Added!")


                    }
                }
            }
        } else {
            print("backImage doesn't exist!")
        }
        

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func imgTapped(_ sender: UITapGestureRecognizer) {
        print("FUNCTION START: imgTapped")
        
        // set global variable imagePicked to tag so we can distinguish between images.
        self.imagePicked = (sender.view?.tag)!
    
        SKCaptionOptions.font = UIFont(name: "GillSans-Bold", size: 30)!
        let browser = SKPhotoBrowser(photos: images)
        
        browser.initializePageIndex(self.imagePicked - 1)
        present(browser, animated: true, completion: {})

    }
    
    
    // MARK: - Helper Functions

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
