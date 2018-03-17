//
//  Button.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit

public final class Button: UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let color = titleColor(for: .normal)?.cgColor
        layer.borderColor = color
        layer.borderWidth = 2
        layer.cornerRadius = 8
    }
    
}
 
