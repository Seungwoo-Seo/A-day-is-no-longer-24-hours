//
//  Identifiable.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/01.
//

import UIKit

protocol ViewIdentifiable: AnyObject {
    static var identifier: String {get}
}

extension UICollectionReusableView: ViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView : ViewIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
