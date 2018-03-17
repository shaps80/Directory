//
//  DetailViewController.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit
import SafariServices

internal final class SiteViewController: UIViewController, StoryboardLoadable {

    @IBOutlet private weak var safariButton: UIButton?
    @IBOutlet private weak var rssButton: UIButton?
    @IBOutlet private weak var twitterButton: UIButton?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var authorLabel: UILabel?
    
    internal var site: Site? {
        didSet { invalidateView() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = localized("title.site")
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .black)
        invalidateView()
    }
    
    private func invalidateView() {
        titleLabel?.text = site?.title
        authorLabel?.text = site?.author
        
        rssButton?.isHidden = site?.feedUrl == nil
        twitterButton?.isHidden = site?.twitterUrl == nil
    }
    
    @IBAction func openInSafari(_ sender: Any) {
        guard let url = site?.siteUrl else { return }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true, completion: nil)
    }
    
    @IBAction func subscribeViaRSS(_ sender: Any) {
        guard let url = site?.feedUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func openInTwitter(_ sender: Any) {
        guard let url = site?.twitterUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
