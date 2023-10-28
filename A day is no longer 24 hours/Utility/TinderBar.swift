//
//  TinderBar.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/27.
//

import Tabman

class TinderBar {

    typealias BarType = TMBarView<TinderBarLayout, TinderBarButton, TMLineBarIndicator>

    static func make() -> TMBar {
        let bar = BarType()

        bar.scrollMode = .swipe

        bar.buttons.customize { (button) in
            button.tintColor = TinderColors.primaryTint
            button.unselectedTintColor = TinderColors.unselectedGray
        }

        bar.backgroundView.style = .flat(color: Constraints.Color.black)
        bar.indicator.weight = .custom(value: 0)

        return bar
    }
}

