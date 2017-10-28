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
    var selectableCells: [Selectable] = ScrollableCellViewModel.dummyCells()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(ScrollableCell.cellSize.height)
        }

        pickerView.register(cellType: ScrollableCell.self)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let randomIndexPath = IndexPath(row: Int(arc4random_uniform(UInt32(selectableCells.count))),section: 0)
        pickerView.scrollToCell(at: randomIndexPath)
    }

    let pickerView: PickerView = {
        let view = PickerView()
        view.selectedOverlayColor = UIColor.cyan
        view.cellSize = ScrollableCell.cellSize
        return view
    }()

}

extension ViewController: PickerViewDelegate {
    func configure(cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let datedCell = cell as? ScrollableCell else { return }
        datedCell.viewModel = selectableCells[indexPath.row] as? ScrollableCellViewModel
    }
}
