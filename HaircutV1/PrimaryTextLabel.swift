//
//  PrimaryTextLabel.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/4/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryTextLabel: UILabel {


    @IBInspectable var fontName : String = "Avenir-Medium" {
        didSet {
            self.configureLabel()
        }
    }
    
    @IBInspectable var fontSize : CGFloat = 14 {
        didSet {
            self.configureLabel()
        }
    }
    
    @IBInspectable var textColorNew : UIColor = hexStringToUIColor(hex: "#1F1F1F") {
        didSet {
            self.configureLabel()
            
        }
    }
    
    // for programmatically created buttons
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    // is for Storyboard/.xib created buttons
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLabel()
    }
    
    // called within the Storyboard editor itself for rendering @IBDesignable controls
    override func prepareForInterfaceBuilder() {
        configureLabel()
    }
    
    // label configuration function called by all init functions.
    func configureLabel() {
        // Common logic goes here
        
        self.textColor = self.textColorNew
        self.font = UIFont(name: self.fontName, size: self.fontSize)
        
    }
    
}
