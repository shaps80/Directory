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
    
    private var filteredCategories: [Category] = [] {
        didSet { tableView.reloadData() }
    }
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        controller.searchBar.tintColor = navigationController?.navigationBar.tintColor
        controller.searchBar.autocorrectionType = .yes
        controller.searchBar.autocapitalizationType = .none
        controller.searchBar.enablesReturnKeyAutomatically = true
        controller.searchResultsUpdater = self
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.startAnimating()
        tableView.backgroundView = activity
        
        title = localized("title.directory", comment: "Directory")
        navigationItem.searchController = searchController

        registerForPreviewing(with: self, sourceView: tableView)
        
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        tableView.registerHeaderFooterNib(cellClass: CategoryHeaderView.self)
        tableView.register(UINib(nibName: "CategoryFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CategoryFooterView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performFetch()
        }
    }
    
    @IBAction private func performFetch() {
        guard tableView.refreshControl?.isRefreshing == false else { return }
        
        fetchRequest.fetch { [weak self] result in
            switch result {
            case let .success(categories):
                self?.categories = categories
                self?.tableView.backgroundView = nil
            case let .failure(error, environment):
                debugPrint("\(error.localizedDescription) | \(environment)")
            }
            
            self?.refreshControl?.endRefreshing()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // we override the storyboard's segue's to provide cleaner peek/pop implementations
        return false
    }

}

extension DirectoryViewController: UISearchControllerDelegate {
    
    private func prepareRefreshControl() {
        refreshControl = UIRefreshControl(frame: .zero)
        refreshControl?.translatesAutoresizingMaskIntoConstraints = false
        refreshControl?.tintColor = view.tintColor
        refreshControl?.addTarget(self, action: #selector(performFetch), for: .valueChanged)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        prepareRefreshControl()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        refreshControl?.endRefreshing()
        refreshControl = nil
    }
    
}

extension DirectoryViewController: UISearchResultsUpdating {
    
    private var isSearching: Bool {
        return searchController.isActive
            && searchController.searchBar.text?.isEmpty == false
    }
    
    private func numberOfCategories() -> Int {
        return isSearching
            ? filteredCategories.count
            : categories.count
    }
    
    private func numberOfSites(for categoryIndex: Int) -> Int {
        return isSearching
            ? filteredCategories[categoryIndex].sites.count
            : categories[categoryIndex].sites.count
    }
    
    private func category(for index: Int) -> Category {
        return isSearching
            ? filteredCategories[index]
            : categories[index]
    }
    
    private func site(for indexPath: IndexPath) -> Site {
        return isSearching
            ? filteredCategories[indexPath.section].sites[indexPath.item]
            : categories[indexPath.section].sites[indexPath.item]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        filteredCategories = categories.compactMap {
            let sites = $0.sites.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
                    || $0.author.localizedCaseInsensitiveContains(searchText)
            }
            
            guard !sites.isEmpty else { return nil }
            return Category(title: $0.title, slug: $0.slug, summary: $0.summary, sites: sites)
        }
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
        view.prepare(with: category(for: section))
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfSites(for: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SiteCell
        let category = self.category(for: indexPath.section)
        let kind: Site.Kind = category.slug.localizedCaseInsensitiveContains("podcast")
            ? .podcast : .blog
        
        cell.prepare(with: site(for: indexPath), kind: kind)
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
        let controller = SiteViewController.fromStoryboard
        controller.site = site(for: indexPath)
        return controller
    }
    
}
