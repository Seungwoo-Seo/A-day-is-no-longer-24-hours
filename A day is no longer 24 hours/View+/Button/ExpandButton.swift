//
//  ExpandButton.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/01.
//

import UIKit

final class ExpandButton: BaseButtton {
    var identifier: String?

    override func initialAttributes() {
        super.initialAttributes()

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.white
        config.background.backgroundColor = Constraints.Color.clear
        configuration = config
        configurationUpdateHandler = { button in
            let config = UIImage.SymbolConfiguration(scale: .small)
            switch button.state {
            case .selected:
                button.configuration?.image = UIImage(systemName: "arrowtriangle.up.fill")?
                    .withConfiguration(config)
            default:
                button.configuration?.image = UIImage(systemName: "arrowtriangle.down.fill")?
                    .withConfiguration(config)
            }
        }
    }

}
