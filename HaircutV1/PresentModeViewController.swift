//
//  PresentModeViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 3/19/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit
import Parse

class PresentModeViewController: UIViewController {

    // MARK: - Segue Preparation Variables
    var modelController: ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("---NEW SCREEN--- FUNCTION START: viewDidLoad - PresentModeViewController.swift")
        print("modelController.haircut = \(modelController.haircut)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
