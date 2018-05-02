//
//  HelpViewController.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 2/16/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet var helpTextView: UITextView!
    @IBOutlet var popupView: UIView!
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        // necessary for image. //popupView.layer.masksToBounds = true
        
    }
    
    // for some reason, to ensure the text starts at the top of the scrollview, I had to disable and enable isScrollEnabled as in the below two functions.
    override func viewWillAppear(_ animated: Bool) {
        self.helpTextView.isScrollEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        print("FUNCTION START: viewDidAppear - HelpViewController.swift")
        self.helpTextView.flashScrollIndicators()
        self.helpTextView.isScrollEnabled = true

    }

}
