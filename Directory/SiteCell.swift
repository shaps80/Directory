//
//  SiteCell.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit

internal final class SiteCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var twitterImageView: UIImageView!
    @IBOutlet private weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        selectedBackgroundView = view
    }
    
    internal func prepare(with site: Site, kind: Site.Kind) {
        titleLabel.text = site.title
        authorLabel.text = site.author
        feedImageView.isHidden = site.feedUrl == nil
        twitterImageView.isHidden = site.twitterUrl == nil
        
        switch kind {
        case .podcast: feedImageView.image = #imageLiteral(resourceName: "podcast")
        case .blog: feedImageView.image = #imageLiteral(resourceName: "feed")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        authorLabel.text = nil
        twitterImageView.isHidden = true
        feedImageView.isHidden = true
        feedImageView.image = nil
    }
    
}
