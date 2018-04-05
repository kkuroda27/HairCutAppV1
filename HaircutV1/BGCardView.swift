//
//  BGCardView.swift
//  HaircutV1
//
//  Created by Kaito Kuroda on 4/4/18.
//  Copyright © 2018 Kai Kuroda Company. All rights reserved.
//

import UIKit

@IBDesignable class BGCardView: UIView {

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
        let scale = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1.52
        
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1

        /*
        self.layer.applySketchShadow(
            color: hexStringToUIColor(hex: "#000000"),
            alpha: 0.22,
            x: 0,
            y: 0,
            blur: 2,
            spread: 0)

        self.layer.applySketchShadow(
            color: hexStringToUIColor(hex: "#000000"),
            alpha: 0.15,
            x: 0,
            y: 2,
            blur: 2,
            spread: 0)
         */

    }
    
}
