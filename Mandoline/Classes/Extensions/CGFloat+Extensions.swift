//
//  CGFloat+Extensions.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import Foundation

extension CGFloat {
    var isIntegral: Bool {
        return self == 0.0 || self.truncatingRemainder(dividingBy: floor(self)) == 0
    }
    var integerBelow: Int {
        return Int(floor(self))
    }
}
