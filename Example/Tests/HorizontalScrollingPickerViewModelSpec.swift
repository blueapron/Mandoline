//
//  HorizontalScrollingPickerViewModelSpec.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import Mandoline

//QuickSpec
class HorizontalScrollingPickerViewModelSpec: QuickSpec {
    override func spec() {
        var subject: HorizontalScrollingPickerViewModel!
        beforeEach {
            subject = HorizontalScrollingPickerViewModel(cells: HorizontalScrollingPickerViewModel.dummyCells())
        }
        describe("init") {
            it("creates a viewModel") {
                expect(subject.cells).to(haveCount(HorizontalScrollingPickerViewModel.dummyCells().count))
            }
        }
        describe("cell selection") {
            it("selects a cell") {
                subject.select(cell: subject.cells[0])
                expect(subject.selectedCell?.isSelectable).to(equal(subject.cells[0].isSelectable))
                subject.select(cell: subject.cells[2])
                expect(subject.selectedCell?.isSelectable).to(equal(subject.cells[2].isSelectable))

            }
        }
    }
}

extension HorizontalScrollingPickerViewModel {
    struct DummyCell: Selectable {
        var isSelectable: Bool
    }
    static func dummyCells() -> [Selectable] {
        var cells: [Selectable] = []
        for _ in 0...10 {
            cells.append(DummyCell(isSelectable: (arc4random_uniform(2) == 1)))
        }
        return cells
    }
}
