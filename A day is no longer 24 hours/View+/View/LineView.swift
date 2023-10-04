//
//  LineView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

enum LineViewStyle {
    case separator
    case timeLine
    case eyewash

    var backgroundColor: UIColor {
        switch self {
        case .separator: return Constraints.Color.separatorBackgroundColor
        case .timeLine: return Constraints.Color.timeLineBackgroundColor
        case .eyewash: return Constraints.Color.clear
        }
    }
}

final class LineView: BaseView {

    convenience init(style: LineViewStyle) {
        self.init(frame: .zero)
        backgroundColor = style.backgroundColor
    }

}
