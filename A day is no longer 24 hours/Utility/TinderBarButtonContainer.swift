//
//  TinderBarButtonContainer.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/27.
//

import UIKit
import Tabman

class TinderBarButtonContainer: UIView {

    // MARK: Properties

    internal let button: TMBarButton

    private var xAnchor: NSLayoutConstraint!

    var offsetDelta: CGFloat = 0.0 {
        didSet {
            xAnchor.constant = offsetDelta * (button.frame.size.width)
        }
    }

    // MARK: Init

    init(for button: TMBarButton) {
        self.button = button
        super.init(frame: .zero)
        initialize(with: button)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Supported")
    }

    private func initialize(with button: TMBarButton) {

        xAnchor = button.centerXAnchor.constraint(equalTo: centerXAnchor)

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //            xAnchor,
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            trailingAnchor.constraint(greaterThanOrEqualTo: button.trailingAnchor)
            ])
    }
}
