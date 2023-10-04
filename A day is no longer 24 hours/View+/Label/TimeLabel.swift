//
//  TimeLabel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

enum TimeLabelStyle {
    case standard
    case eyewash

    var textColor: UIColor {
        switch self {
        case .standard:
            return Constraints.Color.timeLabelTextColor
        case .eyewash:
            return Constraints.Color.clear
        }
    }
}

final class TimeLabel: BaseLabel {

    convenience init(style: TimeLabelStyle) {
        self.init(frame: .zero)

        textColor = style.textColor
        font = Constraints.Font.Sensitive.time
        textAlignment = .center
        text = style == .eyewash ? "00:00" : nil
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

}
