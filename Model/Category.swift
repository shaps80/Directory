//
//  Section.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import Foundation

/**
 Represents a category in `sites.json`
 @example:
    {
        "title": "Official Apple Blogs",
        "slug": "official",
        "description": "All of the iOS development related blogs from our dear friends at the small fruit company in Cupertino.",
        "sites": [ ... ]
    }
 */
public struct Category: Codable {
    
    /// Maps json keys to properties
    ///
    /// - title: The `title` key
    /// - slug: The `slug` key
    /// - summary: The `description` key
    /// - sites: The `sites` key
    public enum CodingKeys: String, CodingKey {
        case title = "title"
        case slug = "slug"
        case summary = "description"
        case sites = "sites"
    }
    
    /// The `title` for this category
    public let title: String
    
    /// The `slug` for this category
    public let slug: String
    
    /// The `description` for this category
    public let summary: String
    
    /// The `sites` associated with this category
    public let sites: [Site]
    
}

extension Category: Comparable {
    
    public static func <(lhs: Category, rhs: Category) -> Bool {
        return lhs.title < rhs.title
    }
    
    public static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.title == rhs.title
    }
    
}
