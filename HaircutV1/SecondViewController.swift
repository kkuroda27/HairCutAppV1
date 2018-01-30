//
//  SecondViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 1/29/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: Outlets
    @IBOutlet var imgLeft: UIImageView!
    @IBOutlet var imgCenter: UIImageView!
    @IBOutlet var imgRight: UIImageView!
    
    // MARK: Extra Variables

    var imagePicked = 1

    // MARK: User Interactions
    
    @IBAction func chooseImg(_ sender: UIButton) {
        print(sender.tag)
        imagePicked = sender.tag
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    

    // MARK: Image Pickers

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

