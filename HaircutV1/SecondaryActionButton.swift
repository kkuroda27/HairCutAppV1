//
//  SecondaryActionButton.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/2/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

@IBDesignable class SecondaryActionButton: UIButton {

    @IBInspectable var fontName : String = "Avenir-Medium" {
        didSet {
            self.configureButton()
        }
    }
    
    @IBInspectable var fontSize : CGFloat = 24 {
        didSet {
            self.configureButton()
        }
    }

    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            self.configureButton()
        }
    }
    
    @IBInspectable var backgroundColorNEW : UIColor = hexStringToUIColor(hex: "#FF9B5A")
        {
        didSet {
            self.configureButton()
            // @IBInspectable var borderColor : UIColor = UIColor.red {
        }
    }
    
    // for programmatically created buttons
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    // is for Storyboard/.xib created buttons
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }
    
    // called within the Storyboard editor itself for rendering @IBDesignable controls
    override func prepareForInterfaceBuilder() {
        configureButton()
    }
    
    // button configuration function called by all init functions.
    func configureButton() {
        // Common logic goes here
        self.clipsToBounds = true
        self.layer.cornerRadius = self.layer.bounds.height / 2.0
        self.layer.backgroundColor = self.backgroundColorNEW.cgColor
        self.layer.applySketchShadow(
            color: hexStringToUIColor(hex: "#FF9B5A"),
            alpha: 0.45,
            x: 0,
            y: 2,
            blur: 2,
            spread: 0)
        
        self.titleLabel?.font = UIFont(name: self.fontName, size: self.layer.bounds.height / 2.3)
        
        //self.titleLabel?.font = UIFont(name: self.fontName, size: self.fontSize)

        self.setTitleColor(.white, for: .normal)
        
        
        self.layer.masksToBounds = true
        //self.layer.borderWidth = self.borderWidth
        
        
    }
    
}

