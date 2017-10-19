//
//  HorizontalScrollingPickerViewModel.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import Foundation

public protocol Selectable {
    var isSelectable: Bool { get set }
}

class HorizontalScrollingPickerViewModel {
    var cells: [Selectable]

    var selectedCell: Selectable?

    func select(cell: Selectable) {
        selectedCell = cell
    }

    init(cells: [Selectable]) {
        self.cells = cells
    }
}

