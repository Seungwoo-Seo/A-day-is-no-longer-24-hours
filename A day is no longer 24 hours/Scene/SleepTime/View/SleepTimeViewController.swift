//
//  SleepTimeViewController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/12.
//

import HGCircularSlider
import UIKit

final class SleepTimeViewController: BaseViewController {
    let containerStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 16
        return view
    }()

    let bedTimeContainerStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    let bedTimeStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 5
        return view
    }()
    let bedTimeImageView = UIImageView(image: UIImage(systemName: "bed.double.fill"))
    let bedTimeTitleLabel = {
        let label = UILabel()
        label.text = "취침 시간"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()
    let bedTimeLabel = {
        let label = UILabel()
        label.text = "12시 00분"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()

    let wakeUpTimeContainerStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 0
        return view
    }()
    let wakeUpTimeStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 5
        return view
    }()
    let wakeUpTimeImageView = UIImageView(image: UIImage(systemName: "bell.fill"))
    let wakeUpTimeTitleLabel = {
        let label = UILabel()
        label.text = "기상 시간"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_17_semibold
        return label
    }()
    let wakeUpTimeLabel = {
        let label = UILabel()
        label.text = "06시 30분"
        label.textColor = Constraints.Color.white
        label.font = Constraints.Font.Insensitive.systemFont_24_semibold
        return label
    }()

    let rangeCircularSlider = {
        let view = RangeCircularSlider(frame: .zero)
        view.backgroundColor = Constraints.Color.black
        view.diskColor = Constraints.Color.clear
        view.diskFillColor = Constraints.Color.black

        view.trackColor = Constraints.Color.lightGray_alpha012
        view.trackFillColor = .orange

        view.lineWidth = 40
        view.backtrackLineWidth = 40

        view.startThumbImage = UIImage(systemName: "moon.zzz.fill")
        view.endThumbImage = UIImage(systemName: "bell.fill")

        return view
    }()
    let durationLabel = UILabel()


    let clockImageView = UIImageView(image: UIImage(named: "clock"))

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func initialAttributes() {
        super.initialAttributes()

        view.backgroundColor = Constraints.Color.black

        rangeCircularSlider.numberOfRounds = 2
        rangeCircularSlider.addTarget(self, action: #selector(updateTexts), for: .valueChanged)


        let dayInSeconds = 24 * 60 * 60
        rangeCircularSlider.maximumValue = CGFloat(dayInSeconds)
        rangeCircularSlider.startPointValue = 1 * 60 * 60
        rangeCircularSlider.endPointValue = 8 * 60 * 60
    }

    @objc func updateTexts(_ sender: AnyObject) {

        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)


        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
//        bedtimeLabel.text = dateFormatter.string(from: bedtimeDate)

        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
//        wakeLabel.text = dateFormatter.string(from: wakeDate)

        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
//        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
    }

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()

    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        [
            rangeCircularSlider,
            clockImageView,
            containerStackView
        ].forEach { view.addSubview($0) }

        [bedTimeContainerStackView,
         wakeUpTimeContainerStackView,].forEach { containerStackView.addArrangedSubview($0) }

        [bedTimeStackView, bedTimeLabel].forEach { bedTimeContainerStackView.addArrangedSubview($0) }

        [bedTimeImageView, bedTimeTitleLabel].forEach { bedTimeStackView.addArrangedSubview($0) }

        [wakeUpTimeStackView, wakeUpTimeLabel].forEach { wakeUpTimeContainerStackView.addArrangedSubview($0) }

        [wakeUpTimeImageView, wakeUpTimeTitleLabel].forEach { wakeUpTimeStackView.addArrangedSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        rangeCircularSlider.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(320)
        }

        clockImageView.snp.makeConstraints { make in
            make.center.equalTo(rangeCircularSlider)
            make.size.equalTo(190)
        }

        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(rangeCircularSlider.snp.top).inset(16)
        }
    }

}
