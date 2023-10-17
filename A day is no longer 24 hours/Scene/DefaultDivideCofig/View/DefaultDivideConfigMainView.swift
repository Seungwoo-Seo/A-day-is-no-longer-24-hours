//
//  DefaultDivideConfigMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/17.
//

import UIKit

final class DefaultDivideConfigMainView: BaseView {
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
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "하루는 더 이상 24시간이 아닙니다. 하루를 나눠서 n배 생산적이고 효율적인 삶을 살아보세요."
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.numberOfLines = 0
        return label
    }()
    private let topAdviceLabel = {
        let label = UILabel()
        label.text = "수면 시간을 제외한 생활시간을 나누게 됩니다."
        label.textColor = Constraints.Color.darkGray
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.numberOfLines = 0
        return label
    }()
    lazy var dateDividePickerView = {
        let view = UIPickerView()
        view.backgroundColor = Constraints.Color.lightGray_alpha012
        view.tintColor = Constraints.Color.white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    private let bottomAdviceLabel = {
        let label = UILabel()
        label.text = "사용자의 생활시간을 알고리즘을 통해 가장 최적화된 일수로 자동 분할했습니다."
        label.textColor = Constraints.Color.darkGray
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        label.numberOfLines = 0
        return label
    }()
    lazy var divideAndStartButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = Constraints.Color.black
        config.background.backgroundColor = Constraints.Color.white
        let button = UIButton(configuration: config)
        return button
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            prevButton,
            dateDividePickerView,
            descriptionLabel,
            topAdviceLabel,
            bottomAdviceLabel,
            divideAndStartButton
        ].forEach { addSubview($0) }

    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 8
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
        }

        dateDividePickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(prevButton.snp.bottom).offset(offset)
            make.bottom.equalTo(topAdviceLabel.snp.top).offset(-offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        topAdviceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(dateDividePickerView.snp.top).offset(-offset)
        }

        bottomAdviceLabel.snp.makeConstraints { make in
            make.top.equalTo(dateDividePickerView.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        divideAndStartButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(bottomAdviceLabel.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(inset*2)
            make.height.equalTo(44)
        }
    }
    

}
