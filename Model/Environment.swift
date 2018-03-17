//
//  Environment.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import Foundation

/// The environment configuration used for requests.
/// Currently this just contains the url for fetching the `sites.json`
public struct Environment {
    
    /// Returns the url for downloading the `sites.json`
    public let url: URL
    
    /// Initializes a new environment. Useful for testing against pull requests and other branches
    ///
    /// - Parameter gitBranch: The branch where `sites.json` exists
    public init(url: URL) {
        self.url = url
    }
    
}

extension Environment {
    
    /// Returns a convenient default instance that points to `master`.
    public static let master = Environment(url: URL(string: "https://raw.githubusercontent.com/daveverwer/iOSDevDirectory/master/sites.json")!)
    
}

extension Environment: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Environment: \(url.absoluteString)"
    }
    
}
