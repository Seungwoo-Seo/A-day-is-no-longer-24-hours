//
//  SceneTransformButton.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/11/27.
//

import UIKit

/// 화면 전환할 때 사용할 버튼
final class SceneTransformButton: BaseButtton {

    init(title: String?) {
        super.init(frame: .zero)
        self.configuration?.title = title
    }

    override func initialAttributes() {
        super.initialAttributes()

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        configuration = config
        setContentHuggingPriority(
            .defaultHigh,
            for: .vertical
        )
        setContentCompressionResistancePriority(
            .defaultHigh,
            for: .vertical
        )
    }

}
