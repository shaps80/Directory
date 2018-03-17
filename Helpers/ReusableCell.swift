//
//  PullRequestCell.swift
//  Review
//
//  Created by Shahpour Benkau on 20/05/2017.
//  Copyright © 2017 DigitasLBi. All rights reserved.
//

import UIKit

/**
 *  Represents a general 'cell' type to provide conformance for UITableViewCell and UICollectionViewCell
 */
public protocol ReusableCell: class {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol ReuseableView: class {
    static var kind: String { get }
}

extension ReuseableView {
    public static var kind: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCell { }
extension UICollectionReusableView: ReusableCell { }
extension UITableViewHeaderFooterView: ReusableCell { }
extension UICollectionReusableView: ReuseableView { }

/**
 *  Represents a general 'view' type to provide conformance for UITableView and UICollectionView. Includes register and dequeue calls so that we can handle both types, or even your own DataView types
 */
public protocol ReusableCellHosting {
    func register<C: ReusableCell>(cellClass: C.Type)
    func dequeueCell<C: ReusableCell>(ofType cellClass: C.Type, for indexPath: IndexPath) -> C
    func dequeueCell<C: ReusableCell>(with identifier: String, for indexPath: IndexPath) -> C
}

extension UITableView: ReusableCellHosting {
    
    public func register<C: ReusableCell>(cellClass: C.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerNib<C: ReusableCell>(cellClass: C.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerHeaderFooterNib<C: ReusableCell>(cellClass: C.Type) {
        register(UINib(nibName: String(describing: cellClass), bundle: nil), forHeaderFooterViewReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeueCell<C: ReusableCell>(ofType cellClass: C.Type, for indexPath: IndexPath) -> C {
        // swiftlint:disable force_cast
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! C
    }
    
    public func dequeueCell<C: ReusableCell>(with identifier: String, for indexPath: IndexPath) -> C {
        // swiftlint:disable force_cast
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! C
    }
    
    public func dequeueHeaderFooterView<C: ReusableCell>(ofType cellClass: C.Type) -> C {
        // swiftlint:disable force_cast
        return dequeueReusableHeaderFooterView(withIdentifier: cellClass.reuseIdentifier) as! C
    }
}

extension UICollectionView {
    
    public func dequeueCell<C: ReusableCell>(ofType cellClass: C.Type, for indexPath: IndexPath) -> C {
        // force_cast
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! C
    }
    
    public func dequeueCell<C: ReusableCell>(with identifier: String, for indexPath: IndexPath) -> C {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! C
    }
    
    public func register<C: ReusableCell>(cellClass: C.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerNib<C: ReusableCell>(for cellClass: C.Type) {
        self.register(UINib(nibName: cellClass.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    // Supplementary views
    
    public func register<C: ReusableCell>(cellClass: C.Type, forKind kind: String) {
        self.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func registerNib<C: ReusableCell>(for cellClass: C.Type, forSupplementaryViewOfKind kind: String) {
        self.register(UINib(nibName: cellClass.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeueSupplementaryView<C: ReusableCell>(ofKind kind: String, ofType cellClass: C.Type, for indexPath: IndexPath) -> C {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! C
    }
}
