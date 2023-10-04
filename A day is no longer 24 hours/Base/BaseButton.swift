//
//  BaseButton.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/01.
//

import SnapKit
import UIKit

class BaseButtton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

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
