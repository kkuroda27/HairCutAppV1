//
//  FullDetailsModeViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/19/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

class FullDetailsModeViewController: UIViewController {

    // MARK: - Segue Preparation Variables
    var modelController: ModelController!
    
    // MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("FUNCTION START: prepareForSegue")
        
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "showEdit":
            print("STATUS: Preparing Segue to Edit Mode")
            
            guard let editModeVC = segue.destination as? CreateHaircutPg1ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            editModeVC.modelController = modelController
            editModeVC.previousVC = "FullDetailsModeViewController"
            editModeVC.isCreating = false

        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - FullDetailsModeViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
