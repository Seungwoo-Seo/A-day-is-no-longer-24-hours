//
//  DefaultTimeConfigMainView.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/17.
//

import HGCircularSlider
import UIKit

final class DefaultTimeConfigMainView: BaseView {
    lazy var nextButtom = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "다음으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    let descriptionLabel = {
        let label = UILabel()
        label.text = "취침 시간과 기상 시간을 알려주세요."
        label.textAlignment = .center
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        label.numberOfLines = 0
        return label
    }()
    private let containerStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 16
        return view
    }()
    private let bedTimeContainerStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    private let bedTimeStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 5
        return view
    }()
    private let bedTimeImageView = UIImageView(
        image: UIImage(systemName: "bed.double.fill")
    )
    private let bedTimeTitleLabel = {
        let label = UILabel()
        label.text = "취침 시간"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()
    let bedTimeLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    private let wakeUpTimeContainerStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    private let wakeUpTimeStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 5
        return view
    }()
    private let wakeUpTimeImageView = UIImageView(
        image: UIImage(systemName: "bell.fill")
    )
    private let wakeUpTimeTitleLabel = {
        let label = UILabel()
        label.text = "기상 시간"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()
    let wakeUpTimeLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    lazy var rangeCircularSlider = {
        let view = RangeCircularSlider(frame: .zero)
        view.backgroundColor = Constraints.Color.black
        view.diskColor = Constraints.Color.clear
        view.diskFillColor = Constraints.Color.black
        view.startThumbTintColor = Constraints.Color.clear
        view.startThumbStrokeColor = Constraints.Color.clear
        view.startThumbStrokeHighlightedColor = Constraints.Color.clear
        view.endThumbTintColor = Constraints.Color.clear
        view.endThumbStrokeColor = Constraints.Color.clear
        view.endThumbStrokeHighlightedColor = Constraints.Color.clear
        view.trackColor = Constraints.Color.lightGray_alpha012
        view.trackFillColor = Constraints.Color.white
        let config = UIImage.SymbolConfiguration(pointSize: 36)
        view.startThumbImage = UIImage(systemName: "bed.double.circle.fill")?.withConfiguration(config)
        view.endThumbImage = UIImage(systemName: "bell.circle.fill")?.withConfiguration(config)
        view.lineWidth = 40
        view.backtrackLineWidth = 40
        view.maximumValue = 24 * 60 * 60
        // startPointValue가 처음에 00:00시에 위치하지 않는 이유는
        // 01월 02일로 데이트가 찍힘
        view.startPointValue = 1 * 60 * 60
        view.endPointValue = 7 * 60 * 60
        return view
    }()
    private let clockImageView = UIImageView(
        image: UIImage(named: "clock")
    )
    let sleepHourAndMinuteLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    let sleepHourToMinuteValidityLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            nextButtom,
            descriptionLabel,
            rangeCircularSlider,
            clockImageView,
            sleepHourAndMinuteLabel,
            sleepHourToMinuteValidityLabel,
            containerStackView
        ].forEach { addSubview($0) }

        [
            bedTimeContainerStackView,
            wakeUpTimeContainerStackView
        ].forEach { containerStackView.addArrangedSubview($0) }

        [
            bedTimeStackView,
            bedTimeLabel
        ].forEach { bedTimeContainerStackView.addArrangedSubview($0) }

        [
            bedTimeImageView,
            bedTimeTitleLabel
        ].forEach { bedTimeStackView.addArrangedSubview($0) }

        [
            wakeUpTimeStackView,
            wakeUpTimeLabel
        ].forEach { wakeUpTimeContainerStackView.addArrangedSubview($0) }

        [
            wakeUpTimeImageView,
            wakeUpTimeTitleLabel
        ].forEach { wakeUpTimeStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        let offset = 16
        let inset = 16
        nextButtom.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButtom.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.equalTo(containerStackView.snp.top).offset(-offset)
        }

        rangeCircularSlider.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(320)
        }

        clockImageView.snp.makeConstraints { make in
            make.center.equalTo(rangeCircularSlider)
            make.size.equalTo(190)
        }

        sleepHourAndMinuteLabel.snp.makeConstraints { make in
            make.top.equalTo(rangeCircularSlider.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        sleepHourToMinuteValidityLabel.snp.makeConstraints { make in
            make.top.equalTo(sleepHourAndMinuteLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(inset)
        }

        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset+4)
            make.bottom.equalTo(rangeCircularSlider.snp.top).inset(inset)
        }
    }

}
