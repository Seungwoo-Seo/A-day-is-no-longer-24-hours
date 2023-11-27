//
//  BaseCollectionViewCell.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, Base {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialAttributes() {}

    func initialHierarchy() {}

    func initialLayout() {}

}
