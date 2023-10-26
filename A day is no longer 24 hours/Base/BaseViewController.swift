//
//  BaseViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import SnapKit
import UIKit

class BaseViewController: UIViewController {

    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(
            nibName: nibNameOrNil,
            bundle: nibBundleOrNil
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialAttributes()
        initialHierarchy()
        initialLayout()
    }

    func initialAttributes() {}

    func initialHierarchy() {}

    func initialLayout() {}

}
