//
//  PickerViewCell.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import UIKit

public class PickerViewCell: UICollectionViewCell, Selectable {
    public var isSelectable = true
    static let cellSize = CGSize(width: 76, height: 94)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        contentView.layer.borderWidth = 1.0
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }
}
