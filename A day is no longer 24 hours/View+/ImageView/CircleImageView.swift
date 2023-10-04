//
//  CircleImageView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/01.
//

import UIKit

enum CircleImageViewStyle {
    case start
    case end
    case eyewash

    var image: UIImage? {
        let config = UIImage.SymbolConfiguration(scale: .small)
        switch self {
        case .start:
            return UIImage(systemName: "circle.fill")?
                .withConfiguration(config)
        case .end:
            return UIImage(systemName: "circle")?
                .withConfiguration(config)
        case .eyewash:
            return UIImage(systemName: "circle.fill")?
                .withConfiguration(config)
        }
    }

    var tintColor: UIColor {
        switch self {
        case .start, .end: return Constraints.Color.circleImageViewTintColor
        case .eyewash: return Constraints.Color.clear
        }
    }
}

final class CircleImageView: BaseImageView {

    convenience init(style: CircleImageViewStyle) {
        self.init(frame: .zero)
        image = style.image
        tintColor = style.tintColor
    }

}
