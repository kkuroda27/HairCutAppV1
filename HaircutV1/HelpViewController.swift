//
//  HelpViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 2/16/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        // necessary for image. //popupView.layer.masksToBounds = true
        
    }

}
