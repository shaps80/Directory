//
//  DirectoryHeader.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit

internal final class CategoryHeaderView: UITableViewHeaderFooterView, NibLoadable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
    }
    
    internal func prepare(with category: Category) {
        titleLabel.text = category.title
        summaryLabel.text = category.summary
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        summaryLabel.text = nil
    }
    
}
