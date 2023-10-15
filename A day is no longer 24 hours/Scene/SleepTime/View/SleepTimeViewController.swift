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
    private lazy var nextButtom = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = Constraints.Color.systemBlue
        config.background.backgroundColor = Constraints.Color.clear
        config.title = "다음으로"
        let button = UIButton(configuration: config)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
        return button
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
    private let sleepHourAndMinuteLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()
    private let sleepHourToMinuteValidityLabel = {
        let label = UILabel()
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
    private let viewModel: SleepTimeViewModel

    // MARK: - Init
    private init(_ viewModel: SleepTimeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModel: SleepTimeViewModel) {
        self.init(viewModel)

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

        viewModel.sleepHourToMinuteFormatString.bind { [weak self] (sleepHourToMinuteFormatString) in
            guard let self else {return}
            self.sleepHourAndMinuteLabel.text = sleepHourToMinuteFormatString
        }

        viewModel.sleepHourToMinuteValidity.bind { [weak self] (bool) in
            guard let self else {return}
            if bool {
                self.nextButtom.isEnabled = true
                self.rangeCircularSlider.trackFillColor = Constraints.Color.white
                self.sleepHourToMinuteValidityLabel.textColor = Constraints.Color.white
                self.sleepHourToMinuteValidityLabel.text = "적절한 수면 시간을 정해보세요!"
            } else {
                self.nextButtom.isEnabled = false
                self.rangeCircularSlider.trackFillColor = Constraints.Color.red
                self.sleepHourToMinuteValidityLabel.textColor = Constraints.Color.red
                self.sleepHourToMinuteValidityLabel.text = "수면 시간이 너무 작거나 너무 큽니다."
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black
    }

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
        nextButtom.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(inset)
        }

        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(inset+4)
            make.bottom.equalTo(rangeCircularSlider.snp.top).inset(inset)
        }
    }

    // MARK: - Event
    @objc
    private func didTapNextButton(
        _ sender: UIButton
    ) {
        // 애초에 nextButton은 활성화가 되어 있어야 tap
        viewModel.nextButtonTapped.value.toggle()
    }

    @objc
    private func valueChangedRangeCircularSlider(
        _ sender: RangeCircularSlider
    ) {
        // TODO: 비즈니스 로직들인데 여기서 직접 사용하는게 맘에 안든다. 근데 메서드 따로 만들어서 했는데 왜 안되는지 모르겠음 - 1
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
