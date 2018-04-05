//
//  InfoCardView.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/4/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

@IBDesignable class InfoCardView: UIView {

    @IBInspectable var backgroundColorNEW : UIColor = hexStringToUIColor(hex: "#FF9B5A")
        {
        didSet {
            self.configureView()
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 4 {
        didSet {
            self.configureView()
        }
    }

    
    // for programmatically created views
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    // is for Storyboard/.xib created views
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    // called within the Storyboard editor itself for rendering @IBDesignable controls
    override func prepareForInterfaceBuilder() {
        configureView()
    }
    
    // button configuration function called by all init functions.
    func configureView() {
        // Common logic goes here
        self.layer.cornerRadius = self.cornerRadius
        //self.layer.cornerRadius = self.layer.bounds.height / 2.0

        self.layer.backgroundColor = self.backgroundColorNEW.cgColor

        
    }
    
}
