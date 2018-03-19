//
//  ViewOptionsViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/19/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse

class ViewOptionsViewController: UIViewController {

    // MARK: - Segue Preparation Variables
    var modelController: ModelController!

    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "showPresentMode":
            print("STATUS: Preparing Segue to Present Mode")
            
            guard let presentModeVC = segue.destination as? PresentModeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            presentModeVC.modelController = modelController
            
        case "showFullDetailsMode":
            print("STATUS: Preparing Segue to FullDetails Mode")
            
            guard let fullDetailsModeVC = segue.destination as? FullDetailsModeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            fullDetailsModeVC.modelController = modelController

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - ViewOptionsViewController")
        print("modelController.haircut = \(modelController.haircut)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
