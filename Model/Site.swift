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
    
    public enum Kind {
        case blog
        case podcast
    }
    
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

extension Site {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        author = try container.decode(String.self, forKey: .author)
        siteUrl = try container.decode(URL.self, forKey: .siteUrl)
        feedUrl = try container.decodeIfPresent(URL.self, forKey: .feedUrl)
        twitterUrl = try container.decodeIfPresent(URL.self, forKey: .twitterUrl)
    }
    
}

extension Site {
    
    /// Returns a Url to fetch the profile photo of the associated Twitter user. When nil, a placeholder image will be used instead.
    public var avatarUrl: URL? {
        guard let username = twitterUrl?.lastPathComponent else { return nil }
        return URL(string: "https://avatars.io/twitter/\(username)")
    }
    
}

extension Site: Comparable {
    
    public static func <(lhs: Site, rhs: Site) -> Bool {
        return lhs.title < rhs.title
    }
    
    public static func ==(lhs: Site, rhs: Site) -> Bool {
        return lhs.title == rhs.title
    }
    
}
