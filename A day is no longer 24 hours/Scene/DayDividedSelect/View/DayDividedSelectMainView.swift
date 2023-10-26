//
//  DayDividedSelectMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/24.
//

import UIKit

final class DayDividedSelectMainView: BaseView {
    // MARK: - View
    lazy var prevButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "이전으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    lazy var nextButtom = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "다음으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "Todo를 추가할 Day를 선택해주세요."
        label.textColor = Constraints.Color.white
        label.textAlignment = .center
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.numberOfLines = 0
        return label
    }()
    lazy var dayDividedPickerView = {
        let view = UIPickerView()
        view.backgroundColor = Constraints.Color.lightGray_alpha012
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            prevButton,
            nextButtom,
            descriptionLabel,
            dayDividedPickerView
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset/4)
            make.leading.equalToSuperview()
        }

        nextButtom.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(offset/4)
            make.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButtom.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(dayDividedPickerView.snp.top).offset(-offset)
        }

        dayDividedPickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(inset)
        }
    }

}
