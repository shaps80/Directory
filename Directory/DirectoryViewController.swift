//
//  MasterViewController.swift
//  Directory
//
//  Created by Shaps Benkau on 16/03/2018.
//  Copyright © 2018 152percent Ltd. All rights reserved.
//

import UIKit

internal final class DirectoryViewController: UITableViewController {

    private let fetchRequest = FetchRequest()
    private var categories: [Category] = [] {
        didSet { tableView.reloadData() }
    }
    
    private lazy var searchController: UISearchController = {
        let directory = UITableViewController(style: .grouped)
        let controller = UISearchController(searchResultsController: directory)
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchResultsUpdater = self
        controller.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.startAnimating()
        tableView.backgroundView = activity
        
        title = localized("title.directory", comment: "Directory")
        navigationItem.largeTitleDisplayMode = .always
        
        registerForPreviewing(with: self, sourceView: tableView)
        
        tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        tableView.registerHeaderFooterNib(cellClass: CategoryHeaderView.self)
        tableView.register(UINib(nibName: "CategoryFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CategoryFooterView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performFetch()
    }
    
    @IBAction private func performFetch() {
        guard fetchRequest.state == .ready else {
            tableView.refreshControl?.endRefreshing()
            return
        }
        
        fetchRequest.fetch { [weak self] result in
            switch result {
            case let .success(categories):
                self?.categories = categories
                self?.tableView.backgroundView = nil
            case let .failure(error, environment):
                debugPrint("\(error.localizedDescription) | \(environment)")
            }
            
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // we override the storyboard's segue's to provide cleaner peek/pop implementations
        return false
    }

}

extension DirectoryViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Update search results...")
    }
    
}

// MARK: UITableView

extension DirectoryViewController {
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoryFooterView")
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueHeaderFooterView(ofType: CategoryHeaderView.self)
        view.prepare(with: categories[section])
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].sites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SiteCell
        let site = categories[indexPath.section].sites[indexPath.item]
        cell.prepare(with: site)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = tableView.rectForRow(at: indexPath).origin
        guard let controller = viewController(for: location) else { fatalError() }
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: Navigation

extension DirectoryViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return viewController(for: location)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
    private func viewController(for location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        let site = categories[indexPath.section].sites[indexPath.item]
        let controller = SiteViewController.fromStoryboard
        
        controller.site = site
        return controller
    }
    
}
