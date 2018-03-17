//
//  File.swift
//  Formula1
//
//  Created by Shaps Benkau on 18/10/2017.
//  Copyright © 2017 DigitasLBi. All rights reserved.
//

import UIKit

/// Represents any type that can be loaded via a Storyboard
public protocol StoryboardLoadable {
    
    /// Returns an instance of `Self` from a storyboard. Uses 'Main' for the storyboard and String(describing: self) to determine the identifier.
    static var fromStoryboard: Self { get }
    static func fromStoryboard(named name: String, initial: Bool) -> Self
    
    /// Returns an instance of `Self` from a storyboard.
    ///
    /// - Parameters:
    ///   - name: The name of the storyboard
    ///   - identifier: The identifier used to represent this controller
    /// - Returns: A new instance of this type
    static func fromStoryboard(named name: String, identifier: String) -> Self
    
}

extension StoryboardLoadable where Self: UIViewController {
    
    private static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    /// Returns an instance of `Self` from a storyboard. Uses 'Main' for the storyboard and String(describing: self) to determine the identifier.
    public static var fromStoryboard: Self {
        return fromStoryboard(identifier: String(describing: self))
    }
    
    public static func fromStoryboard(named name: String, initial: Bool = false) -> Self {
        if initial {
            guard let controller = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() as? Self else {
                fatalError("Instantiation of \(String(describing: self)) from storyboard \(name) failed")
            }
            
            return controller
        }
        
        let identifier = String(describing: self)
        return fromStoryboard(named: name, identifier: identifier)
    }
    
    /// Returns an instance of `Self` from a storyboard.
    ///
    /// - Parameters:
    ///   - name: The name of the storyboard
    ///   - identifier: The identifier used to represent this controller
    /// - Returns: A new instance of this type
    public static func fromStoryboard(named name: String = "Main", identifier: String) -> Self {
        guard let controller = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Instantiation of \(String(describing: self)) from storyboard \(name) failed")
        }
        
        return controller
    }
    
}
