//
//  IPlayButton.swift
//  iPLay
//
//  Created by javier pineda on 26/09/25.
//

import UIKit

@IBDesignable
class IPlayButton: UIButton {
    
    @IBInspectable
    var isActive: Bool = false {
        didSet {
            backgroundColor = isActive ? .red: .systemGray6
            isEnabled = isActive
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 8
    }
}
