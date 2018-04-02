//
//  PrimaryActionButton.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/2/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryActionButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 30 {
        didSet {
            self.configureButton()
        }
    }
    
    
    /*
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.configureButton()
        }
    }
    */
    
    @IBInspectable var backgroundColorNEW : UIColor = hexStringToUIColor(hex: "#35B18E")
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

        self.layer.cornerRadius = self.cornerRadius
        self.layer.backgroundColor = self.backgroundColorNEW.cgColor
        self.layer.applySketchShadow(
            color: hexStringToUIColor(hex: "#67C2AC"),
            alpha: 0.5,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)

        self.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 24)
        
        self.setTitleColor(.white, for: .normal)

        //self.layer.borderWidth = self.borderWidth

        
    }

}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}


