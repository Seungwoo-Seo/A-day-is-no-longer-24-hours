//
//  AdviceLabel.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/11/27.
//

import UIKit

/// 조언을 하고 싶을 때 사용할 레이블
final class AdviceLabel: BaseLabel {

    init(text: String?) {
        super.init(frame: .zero)
        self.text = text
    }

    override func initialAttributes() {
        super.initialAttributes()

        textColor = Constraints.Color.darkGray
        font = Constraints.Font.Insensitive.systemFont_17_semibold
        numberOfLines = 0
    }

}

