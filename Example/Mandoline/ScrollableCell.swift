//
//  ScrollableCell.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Mandoline
import SnapKit

class ScrollableCell: UICollectionViewCell {

    let dayLabel = UILabel()
    let dateLabel = UILabel()

    var viewModel: ScrollableCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            dayLabel.text = viewModel.dayLabelText
            dateLabel.text = viewModel.dateLabelText
        }
    }
    static let cellSize = CGSize(width: 90, height: 100)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        contentView.layer.borderWidth = 1.0
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScrollableCellViewModel: Selectable {

    let threeLetterWeekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE"
        return formatter
    }()

    let singleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "d"
        return formatter
    }()

    var date: Date? {
        didSet {
            guard let date = date else { return }
            dateLabelText = singleDateFormatter.string(from: date)
            dayLabelText = threeLetterWeekdayFormatter.string(from: date)
        }
    }

    var dayLabelText: String?

    var dateLabelText: String?

    var isSelectable: Bool

    init(isSelectable: Bool) {
        self.isSelectable = isSelectable
    }

}

extension ScrollableCellViewModel {
    static func dummyCells() -> [ScrollableCellViewModel] {
        let today = Date()
        var cells: [ScrollableCellViewModel] = []
        for i in 0...10 {
            let isSelectable = arc4random_uniform(2) == 1
            let cellVM = ScrollableCellViewModel(isSelectable: isSelectable)
            cellVM.date = Calendar.current.date(byAdding: .day, value: i, to: today)
            cells.append(cellVM)
        }
        return cells
    }
}

