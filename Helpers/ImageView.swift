//
//  ImageView.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit

@IBDesignable
final class ImageView: UIImageView {
    
    override func prepareForInterfaceBuilder() {
        self.configure()
    }
    
    private var _backgroundColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    override var tintColor: UIColor! {
        didSet { self.configure() }
    }
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            super.isHighlighted = newValue
            
            if !highlightAdjustsImage {
                backgroundColor = _backgroundColor
            }
        }
    }
    
    @IBInspectable var highlightAdjustsImage: Bool = false
    
    private func configure() {
        _backgroundColor = backgroundColor
        
        if self.image?.renderingMode != .alwaysOriginal {
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
        
        self.layer.cornerRadius = self.layer.cornerRadius
        
        // This seems to be required in order to get the imageView to refreshLayout its tinteColor correctly
        let tintColor = super.tintColor
        super.tintColor = .clear
        super.tintColor = tintColor
    }
    
}
