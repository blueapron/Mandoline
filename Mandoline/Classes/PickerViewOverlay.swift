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

    private var triangleViewSizeConstraints: SizeConstraints?
    
    // Computed Properties
    var triangleSize = CGSize(width: 10, height: 5) {
        didSet {
            let rect = CGRect(origin: .zero, size: triangleSize)
            triangleViewSizeConstraints?.updateSize(to: triangleSize)
            triangleView.frameToFill = rect
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

    private var imageViewSizeConstraints: SizeConstraints?
    var dotSize = CGSize(width: 8, height: 8) {
        didSet {
            imageViewSizeConstraints?.updateSize(to: dotSize)
        }
    }

    private var imageViewTopConstraint: NSLayoutConstraint?
    var dotDistanceFromTop: CGFloat = 70 {
        didSet {
            imageViewTopConstraint?.constant = dotDistanceFromTop
        }
    }

    override init(frame: CGRect) {
        view = UIView(frame: .zero)
        super.init(frame: frame)
        setupSubviews()
    }

    func setupSubviews() {
        addSubview(view)
        view.equalEdges(to: self)
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.cgColor

        addSubview(imageView)
        imageViewTopConstraint = imageView.equal(.top, to: self, offset: dotDistanceFromTop)
        imageView.equal(.centerX, to: self)

        imageView.tintColor = dotColor
        imageViewSizeConstraints = imageView.equalSize(to: dotSize)

        addSubview(triangleView)
        triangleView.equal(.top, to: self)
        triangleView.equal(.centerX, to: self)
        triangleViewSizeConstraints = triangleView.equalSize(to: triangleSize)
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

    var color = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    var frameToFill: CGRect? {
        didSet {
            setNeedsLayout()
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
