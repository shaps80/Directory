//
//  NavigationController.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit

internal final class SplitViewController: UISplitViewController {
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }
    
}

internal final class NavigationController: UINavigationController {
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}
