//
//  BaseTableViewHeaderFooterView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/22.
//

import SnapKit
import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialAttributes() {}

    func initialHierarchy() {}

    func initialLayout() {}

}
