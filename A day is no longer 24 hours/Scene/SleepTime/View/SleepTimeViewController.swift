//
//  SleepTimeViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import HGCircularSlider
import UIKit

final class SleepTimeViewController: BaseViewController {
    // MARK: - View
    private lazy var nextBarButtomItem = {
        let buttonItem = UIBarButtonItem(
            title: "다음으로 >",
            style: .plain,
            target: self,
            action: #selector(didTapNextBarButtonItem)
        )
        return buttonItem
    }()
    private let descriptionLabel = {
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
    private let bedTimeLabel = {
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
    private let wakeUpTimeLabel = {
        let label = UILabel()
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    private lazy var rangeCircularSlider = {
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
        view.addTarget(
            self,
            action: #selector(valueChangedRangeCircularSlider),
            for: .valueChanged
        )
        return view
    }()
    private let clockImageView = UIImageView(
        image: UIImage(named: "clock")
    )
    private let sleepTimeLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    private let sleepTimeValidityLabel = {
        let label = UILabel()
//        label.text = "이렇게 시간을 지정하면 수면 목표를 충족합니다."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()

    // MARK: - DateFormatter, View에 있어도 말이 되는거 같고, ViewModel에 있어도 말이 되는데 고민되네
    private let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(
            abbreviation: "UTC"
        )
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()

    // MARK: - ViewModel
    private let viewModel = SleepTimeViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        navigationItem.rightBarButtonItem = nextBarButtomItem

        [
            descriptionLabel,
            rangeCircularSlider,
            clockImageView,
            sleepTimeLabel,
            sleepTimeValidityLabel,
            containerStackView
        ].forEach { view.addSubview($0) }

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
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        rangeCircularSlider.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(320)
        }

        clockImageView.snp.makeConstraints { make in
            make.center.equalTo(rangeCircularSlider)
            make.size.equalTo(190)
        }

        sleepTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(rangeCircularSlider.snp.bottom).offset(offset)
            make.horizontalEdges.equalToSuperview().inset(inset)
        }

        sleepTimeValidityLabel.snp.makeConstraints { make in
            make.top.equalTo(sleepTimeLabel.snp.bottom).offset(offset/2)
            make.horizontalEdges.equalToSuperview().inset(inset)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(inset)
        }

        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset+4)
            make.bottom.equalTo(rangeCircularSlider.snp.top).inset(inset)
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom)
        }
    }

    // MARK: - Bind
    private func bind() {

        viewModel.bedTime.bind { [weak self] (bedTime) in
            guard let self else {return}
            self.dateFormatter.dateFormat = "a HH:mm"
            self.bedTimeLabel.text = self.dateFormatter.string(from: bedTime)
        }

        viewModel.wakeUpTime.bind { [weak self] (wakeUpTime) in
            guard let self else {return}
            self.dateFormatter.dateFormat = "a HH:mm"
            self.wakeUpTimeLabel.text = self.dateFormatter.string(from: wakeUpTime)
        }

        viewModel.sleepTime.bind { [weak self] (sleepTime) in
            guard let self else {return}
            self.dateFormatter.dateFormat = "H 시간 m 분"
            self.sleepTimeLabel.text = self.dateFormatter.string(from: sleepTime)
        }

        viewModel.sleepTimeValidity.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.nextBarButtomItem.isEnabled = true
                self.rangeCircularSlider.trackFillColor = Constraints.Color.white
                self.sleepTimeValidityLabel.textColor = Constraints.Color.white
                self.sleepTimeValidityLabel.text = "적절한 수면 시간을 정해보세요!"
            } else {
                self.nextBarButtomItem.isEnabled = false
                self.rangeCircularSlider.trackFillColor = Constraints.Color.red
                self.sleepTimeValidityLabel.textColor = Constraints.Color.red
                self.sleepTimeValidityLabel.text = "수면 시간이 너무 작거나 너무 큽니다."
            }
        }
    }

    // MARK: - Event
    @objc
    private func didTapNextBarButtonItem(
        _ sender: UIBarButtonItem
    ) {
        let vc = DateDivideViewController()
        navigationController?.pushViewController(
            vc, animated: true
        )
    }

    @objc
    private func valueChangedRangeCircularSlider(
        _ sender: RangeCircularSlider
    ) {
        viewModel.adjustValue(
            value: &sender.startPointValue
        )
        viewModel.adjustValue(
            value: &sender.endPointValue
        )
        viewModel.updateTimes(
            startPointValue: sender.startPointValue,
            endPointValue: sender.endPointValue
        )
    }

}
