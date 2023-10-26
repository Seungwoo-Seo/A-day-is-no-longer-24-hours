//
//  DetailTodoHeader.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/30.
//

import UIKit

protocol DetailTodoHeaderProtocol: AnyObject {
    func didTapExpandButton(_ sender: ExpandButton)
    func didTapDetailTodoHeader(_ todo: TodoStruct)
}

final class DetailTodoHeader: BaseCollectionReusableView {
    // MARK: - View
    private let startTimeLabel = TimeLabel(style: .standard)
    private let startCircleImageView = CircleImageView(style: .start)
    private let timeLineView = LineView(style: .timeLine)
    private let startHorizontalView = LineView(style: .separator)
    private let startTitleLabel = TitleLabel(style: .start)
    let expandButton = ExpandButton()

    // MARK: - Delegate
    weak var delegate: DetailTodoHeaderProtocol?

    private var todo: TodoStruct?

    // MARK: - Configure
    func configure(
        _ delegate: DetailTodoHeaderProtocol?,
        todo: TodoStruct
    ) {
        self.delegate = delegate
        self.todo = todo
        startTimeLabel.text = todo.startTimeToString
        startTitleLabel.setTitle(
            category: todo.category,
            title: todo.subTitle
        )
        expandButton.identifier = todo.hashValue
    }

    // MARK: - Initial Setting
    override func initialAttributes() {
        super.initialAttributes()

        expandButton.addTarget(self, action: #selector(didTapExpandButton), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDetailTodoHeader))
        addGestureRecognizer(tap)
    }

    @objc
    func didTapDetailTodoHeader() {
        guard let todo else {return}
        delegate?.didTapDetailTodoHeader(todo)
    }

    @objc
    func didTapExpandButton(_ sender: ExpandButton) {
        delegate?.didTapExpandButton(sender)
    }



    override func initialHierarchy() {
        super.initialHierarchy()

        [
            startTimeLabel,
            startCircleImageView,
            timeLineView,
            startHorizontalView,
            startTitleLabel,
            expandButton
        ].forEach { addSubview($0) }
    }

    override func initialLayout() {
        super.initialLayout()

        startTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
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

        expandButton.snp.makeConstraints { make in
            make.centerY.equalTo(startTimeLabel)
            make.trailing.bottom.equalToSuperview()
        }
    }
}
