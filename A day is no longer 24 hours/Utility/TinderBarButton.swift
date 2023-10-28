//
//  TinderBarButton.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/27.
//

import UIKit
import Tabman

class TinderBarButton: TMBarButton {

    // MARK: Defaults

    private struct Defaults {
        static let imageSize = CGSize(width: 50, height: 36)
        static let unselectedScale: CGFloat = 0.8
    }

    // MARK: Properties
//    private let image = UIImage() --> 이미지 쓰고 싶다면

    private let label = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constraints.Color.black
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()

    override var tintColor: UIColor! {
        didSet {
            update(for: self.selectionState)
        }
    }
    var unselectedTintColor: UIColor = .lightGray {
        didSet {
            update(for: self.selectionState)
        }
    }

    // MARK: Lifecycle

    override func layout(in view: UIView) {
        super.layout(in: view)

        adjustsAlphaOnSelection = false

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.widthAnchor.constraint(equalToConstant: Defaults.imageSize.width),
            label.heightAnchor.constraint(equalToConstant: Defaults.imageSize.height)
            ])
    }

    override func populate(for item: TMBarItemable) {
        super.populate(for: item)

        label.text = item.title
//        imageView.image = item.image
    }

    override func update(for selectionState: TMBarButton.SelectionState) {
        super.update(for: selectionState)

        label.textColor = unselectedTintColor.interpolate(with: tintColor, percent: selectionState.rawValue)

        let scale = 1.0 - ((1.0 - selectionState.rawValue) * (1.0 - Defaults.unselectedScale))
        label.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
