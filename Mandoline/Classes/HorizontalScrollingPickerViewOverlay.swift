//
//  HorizontalScrollingPickerViewOverlay.swift
//  Mandoline
//
//  Created by Anat Gilboa on 10/18/2017.
//  Copyright (c) 2017 ag. All rights reserved.
//

import UIKit

class HorizontalScrollingPickerViewOverlay: UIView {
    let view: UIView
    let imageView = UIImageView()
    let triangleView = HorizontalScrollingPickerViewOverlayTriangleView()

    // Computed Properties
    var triangleSize = CGSize(width: 10, height: 5) {
        didSet {
            let rect = CGRect(origin: .zero, size: triangleSize)
            triangleView.setFill(frame: rect)
        }
    }

    var borderColor = UIColor.blue {
        didSet {
            view.layer.borderColor = borderColor.cgColor
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

    var distanceOfDotFromTop: CGFloat = 70 {
        didSet {
            imageView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(distanceOfDotFromTop)
            }
        }
    }

    func setFill(color: UIColor) {
        borderColor = color
        triangleView.setFill(with: color)
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
            make.top.equalToSuperview().offset(distanceOfDotFromTop)
            make.centerX.equalToSuperview()
        }

        imageView.image = UIImage(named: "GreenDot")?.withRenderingMode(.alwaysTemplate)
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
class HorizontalScrollingPickerViewOverlayTriangleView: UIView {

    // We have to override the init just because we need to set isOpaque to false
    override init(frame: CGRect) {
        super.init(frame: .zero)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFill(with color: UIColor? = nil, frame: CGRect? = nil) {
        UIColor.clear.setFill()
        if let color = color {
            color.setFill()
        } else {
            UIColor.blue.setFill()
        }

        if let rect = frame {
            UIBezierPath(rect: rect).fill()
            draw(rect)
        } else {
            UIBezierPath(rect: layer.frame).fill()
            draw(layer.frame)
        }
    }

    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: layer.frame.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: layer.frame.width / 2, y: layer.frame.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.close()
        bezierPath.fill()
    }
}
