//
//  PullRequestCell.swift
//  Review
//
//  Created by Shahpour Benkau on 20/05/2017.
//  Copyright © 2017 DigitasLBi. All rights reserved.
//

import UIKit

/// Represents any type that can be loaded via a XIB/NIB
public protocol NibLoadable {
    
    static var nib: UINib { get }
    
    static var nibName: String { get }
    
    /// Returns an instance of `Self` from a nib. Uses String(describing: self) to determine the name of the nib.
    static var fromNib: Self { get }
    
    /// Returns an instance of `Self` from a nib.
    ///
    /// - Parameter name: The name of the nib
    /// - Returns: A new instance of this type
    static func fromNib(named name: String, withOwner ownerOrNil: Any?, options optionsOrNil: [AnyHashable: Any]?) -> Self
    
}

extension NibLoadable where Self: UIViewController {
    /// Returns an instance of `Self` from a nib. Uses String(describing: self) to determine the name of the nib.
    public static var fromNib: Self {
        return fromNib(named: String(describing: self), withOwner: nil, options: nil)
    }
    
    public static var nibName: String {
        return String(describing: self)
    }
    
    /// Returns an instance of `Self` from a nib.
    ///
    /// - Parameter name: The name of the nib
    /// - Returns: A new instance of this type
    public static func fromNib(named name: String, withOwner ownerOrNil: Any? = nil, options optionsOrNil: [AnyHashable: Any]? = nil) -> Self {
        return Self(nibName: name, bundle: nil)
    }
}

extension NibLoadable where Self: UIView {
    
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    /// Returns an instance of `Self` from a nib. Uses String(describing: self) to determine the name of the nib.
    public static var fromNib: Self {
        return fromNib(named: nibName)
    }
    
    /// Returns an instance of `Self` from a nib.
    ///
    /// - Parameter name: The name of the nib
    /// - Returns: A new instance of this type
    public static func fromNib(named name: String, withOwner ownerOrNil: Any? = nil, options optionsOrNil: [AnyHashable: Any]? = nil) -> Self {
        guard let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: ownerOrNil, options: optionsOrNil).first as? Self else {
            fatalError("Instantiation of \(nibName) from a nib failed")
        }
        
        return view
    }
    
}
