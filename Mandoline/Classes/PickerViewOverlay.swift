//
//  PickerViewOverlay.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import UIKit

class PickerViewOverlay: UIView {

    let view: UIView

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "HandleGreen", in: Bundle(for: PickerView.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()

    let triangleView = PickerViewOverlayTriangleView()

    // Computed Properties
    var triangleSize = CGSize(width: 10, height: 5) {
        didSet {
            let rect = CGRect(origin: .zero, size: triangleSize)
            triangleView.frameToFill = rect
            setNeedsLayout()
        }
    }

    var borderColor = UIColor.blue {
        didSet {
            view.layer.borderColor = borderColor.cgColor
            triangleView.color = borderColor
        }
    }

    var borderWidth: CGFloat = 2.0 {
        didSet {
            view.layer.borderWidth = borderWidth
        }
    }

    var dotColor: UIColor? = UIColor.green {
        didSet {
            imageView.tintColor = dotColor
        }
    }

    var sizeOfDot = CGSize(width: 8, height: 8) {
        didSet {
            imageView.snp.updateConstraints { make in
                make.size.equalTo(sizeOfDot)
            }
        }
    }

    var dotDistanceFromTop: CGFloat = 70 {
        didSet {
            imageView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(dotDistanceFromTop)
            }
        }
    }

    override init(frame: CGRect) {
        view = UIView(frame: .zero)
        super.init(frame: frame)
        setupSubviews()
    }

    func setupSubviews() {
        addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(dotDistanceFromTop)
            make.centerX.equalToSuperview()
        }

        imageView.tintColor = dotColor
        imageView.snp.makeConstraints { make in
            make.size.equalTo(sizeOfDot)
        }

        addSubview(triangleView)
        triangleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(triangleSize)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// This is the downward pointing arrow in the OverlayView
class PickerViewOverlayTriangleView: UIView {

    // We have to override the init just because we need to set isOpaque to false
    override init(frame: CGRect) {
        super.init(frame: .zero)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // In case 
    var color = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    var frameToFill: CGRect? {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        let frame = frameToFill ?? layer.frame
        UIBezierPath(rect: frame).fill()
        color.setFill()

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: frame.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: frame.width / 2, y: frame.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        bezierPath.fill()
    }
}
