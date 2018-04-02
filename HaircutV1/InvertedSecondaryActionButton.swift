//
//  InvertedSecondaryActionButton.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/2/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

@IBDesignable class InvertedSecondaryActionButton: UIButton {
    
    @IBInspectable var cornerRadius : CGFloat = 30 {
        didSet {
            self.configureButton()
        }
    }
    
     @IBInspectable var borderWidth : CGFloat = 4 {
        didSet {
            self.configureButton()
        }
     }
    @IBInspectable var borderColor : UIColor = hexStringToUIColor(hex: "#FF9B5A") {
        didSet {
            self.configureButton()
            
        }
    }


    @IBInspectable var backgroundColorNEW : UIColor = UIColor.white {
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
        
        self.layer.cornerRadius = self.cornerRadius
        self.layer.backgroundColor = self.backgroundColorNEW.cgColor
        self.layer.applySketchShadow(
            color: hexStringToUIColor(hex: "#FF9B5A"),
            alpha: 0.45,
            x: 0,
            y: 2,
            blur: 2,
            spread: 0)
        
        self.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 24)
        
        self.setTitleColor(hexStringToUIColor(hex: "#FF9B5A"), for: .normal)
        
        self.layer.borderWidth = self.borderWidth
        
        self.layer.borderColor = self.borderColor.cgColor
        
        
    }
    
}
