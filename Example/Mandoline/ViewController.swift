//
//  ViewController.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import Mandoline
import SnapKit

class ViewController: UIViewController, PickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(ScrollableCell.cellSize.height)
        }

        calendarView.register(cellType: ScrollableCell.self)
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let randomIndexPath = IndexPath(row: Int(arc4random_uniform(UInt32(selectableCells.count))),section: 0)
        calendarView.scrollToCell(at: randomIndexPath)
    }

    let calendarView: PickerView = {
        let view = PickerView()
        view.cellSize = ScrollableCell.cellSize
        return view
    }()

    var selectableCells: [Selectable] = ScrollableCellViewModel.dummyCells()
}

extension ViewController: PickerViewDelegate {

    func collectionView(_ view: PickerView, didSelectItemAt indexPath: IndexPath) {

    }

    func scrollViewWillBeginDragging(_ view: PickerView) {

    }

    func scrollViewWillEndDragging(_ view: PickerView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    func configure(cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let datedCell = cell as? ScrollableCell else { return }
        datedCell.viewModel = selectableCells[indexPath.row] as? ScrollableCellViewModel
    }
}
