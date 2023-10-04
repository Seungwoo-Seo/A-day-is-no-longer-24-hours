//
//  StateButton.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/01.
//

import UIKit

final class StateButton: BaseButtton {

    override func initialAttributes() {
        super.initialAttributes()

        let config = UIButton.Configuration.plain()
        configuration = config
        configurationUpdateHandler = { button in
            let config = UIImage.SymbolConfiguration(scale: .small)
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "square.fill")?.withConfiguration(config)
                button.configuration?.baseForegroundColor = Constraints.Color.green
                button.configuration?.background.backgroundColor = Constraints.Color.clear
            default:
                button.configuration?.image = UIImage(systemName: "square")?.withConfiguration(config)
                button.configuration?.baseForegroundColor = Constraints.Color.white
            }
        }
        setContentHuggingPriority(.init(1000), for: .horizontal)
        setContentCompressionResistancePriority(.init(1000), for: .horizontal)
    }

}   
