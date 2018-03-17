//
//  Site.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import Foundation

/**
 Represents a website in `sites.json`
 @example:
    {
        "title": "Site title",
        "author": "Site author",
        "site_url": "http://...",
        "feed_url": "http://.../feed",
        "twitter_url": "https://twitter.com/username"
    }
 */
public struct Site: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case title = "title"
        case author = "author"
        case siteUrl = "site_url"
        case feedUrl = "feed_url"
        case twitterUrl = "twitter_url"
    }
    
    public let title: String
    public let author: String
    public let siteUrl: URL
    public let feedUrl: URL?
    public let twitterUrl: URL?
    
}

extension Site: Comparable {
    
    public static func <(lhs: Site, rhs: Site) -> Bool {
        return lhs.title < rhs.title
    }
    
    public static func ==(lhs: Site, rhs: Site) -> Bool {
        return lhs.title == rhs.title
    }
    
}
