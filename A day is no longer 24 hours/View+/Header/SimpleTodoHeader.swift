//
//  SimpleTodoHeader.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

protocol SimpleTodoHeaderProtocol: AnyObject {
    func didTapSimpleTodoHeader(_ todo: TodoStruct)
}

final class SimpleTodoHeader: BaseCollectionReusableView {
    // MARK: - View
    private let standardHorizontalView = LineView(style: .eyewash)
    // start area
    private let startTimeLabel = TimeLabel(style: .standard)
    private let startCircleImageView = CircleImageView(style: .start)
    private let timeLineView = LineView(style: .timeLine)
    private let startHorizontalView = LineView(style: .separator)
    private let startTitleLabel = TitleLabel(style: .start)
    private let stateButton = StateButton()

    // end area
    private let endTimeLabel = TimeLabel(style: .standard)
    private let endCircleImageView = CircleImageView(style: .end)
    private let endHorizontalView = LineView(style: .separator)
    private let joinVerticalView = LineView(style: .separator)

    weak var delegate: SimpleTodoHeaderProtocol?

    private var todo: TodoStruct?

    // MARK: - Configure
    func configure(
        _ delegate: SimpleTodoHeaderProtocol?,
        todo: TodoStruct
    ) {
        self.delegate = delegate
        self.todo = todo
        startTimeLabel.text = todo.startTimeToString
        startTitleLabel.setTitle(
            category: todo.category,
            title: todo.subTitle
        )
        endTimeLabel.text = todo.endTimeToString
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSimpleTodoHeader))
        addGestureRecognizer(tap)
    }

    @objc
    func didTapSimpleTodoHeader() {
        guard let todo else {return}
        delegate?.didTapSimpleTodoHeader(todo)
    }

    override func initialHierarchy() {
        super.initialHierarchy()

        addSubview(standardHorizontalView)

        // start
        [
            startTimeLabel,
            startCircleImageView,
            timeLineView,
            startHorizontalView,
            startTitleLabel
//            stateButton
        ].forEach { addSubview($0) }

        // end
        [
            endTimeLabel,
            endCircleImageView,
            endHorizontalView,
            joinVerticalView
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        // MARK: - standard
        standardHorizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        // MARK: - start
        startTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalTo(standardHorizontalView.snp.top).offset(-8)
            make.top.equalToSuperview().inset(16)
        }

        startCircleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(startTimeLabel)
            make.leading.equalTo(startTimeLabel.snp.trailing).offset(8)
        }

        timeLineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.centerX.equalTo(startCircleImageView)
            make.verticalEdges.equalToSuperview()
        }

        startHorizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(16)
            make.centerY.equalTo(startTimeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
        }

        startTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(startHorizontalView.snp.trailing).offset(4)
            make.centerY.equalTo(startTimeLabel)
        }

//        stateButton.snp.makeConstraints { make in
//            make.leading.equalTo(startTitleLabel.snp.trailing)
//            make.trailing.lessThanOrEqualToSuperview()
//            make.centerY.equalTo(startTimeLabel)
//        }

        // MARK: - end
        endTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(standardHorizontalView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
        }

        endCircleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(endTimeLabel)
            make.leading.equalTo(endTimeLabel.snp.trailing).offset(8)
        }

        endHorizontalView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(endTimeLabel)
            make.leading.equalTo(timeLineView.snp.trailing)
            make.trailing.equalTo(startTitleLabel.snp.centerX)
        }

        joinVerticalView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.equalTo(startTitleLabel.snp.bottom)
            make.leading.equalTo(endHorizontalView.snp.trailing)
            make.bottom.equalTo(endHorizontalView.snp.bottom)
        }
    }

}
