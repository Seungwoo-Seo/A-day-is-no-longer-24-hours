//
//  TitleLabel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

enum TitleLabelStyle {
    case start
    case end
    case todo

    var textColor: UIColor {
        return Constraints.Color.titleLabelTextColor
    }
}

final class TitleLabel: BaseLabel {

    private var style: TitleLabelStyle = .start

    convenience init(style: TitleLabelStyle) {
        self.init(frame: .zero)
        self.style = style
        textColor = style.textColor
    }

    func setTitle(category: String?, title: String?) {
        switch style {
        case .start:
            guard let category else {fatalError("start 스타일일 때 카테고리와 타이틀은 필수입니다.")}
            let categoryAtt = NSMutableAttributedString(
                string: category,
                attributes: [
                    .font: Constraints.Font.Insensitive.category
                ]
            )

            if let title {
                let titleAtt = NSMutableAttributedString(
                    string: ": \(title)",
                    attributes: [
                        .font: Constraints.Font.Insensitive.title
                    ]
                )
                categoryAtt.append(titleAtt)
            }
            attributedText = categoryAtt

        case .end, .todo:
            guard let title else {fatalError("end, todo 스타일일 때 title을 필수입니다.")}
            text = title
        }
    }

}
