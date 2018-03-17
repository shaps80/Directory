//
//  Localization.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import Foundation

/// A helper function to simplify the creation of an NSLocalizedString
///
/// - Parameters:
///   - string: The string to localize
///   - comment: The comment for this string
/// - Returns: A localized string
public func localized(_ string: String, comment: String? = nil) -> String {
    return NSLocalizedString(string, comment: comment ?? "")
}
