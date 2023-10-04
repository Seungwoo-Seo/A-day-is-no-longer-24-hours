//
//  Identifiable.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/01.
//

import UIKit

protocol Identifiable: AnyObject {
    static var identifier: String {get}
}

extension UICollectionReusableView: Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
