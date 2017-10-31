//
//  UIView+AutoLayout.swift
//  Mandoline
//
//  Created by Francesco Perrotti Garcia on 10/30/17.
//

import Foundation

struct SizeConstraints {
    let width: NSLayoutConstraint
    let height: NSLayoutConstraint
    
    func updateSize(to size: CGSize) {
        width.constant = size.width
        height.constant = size.height
    }
}

extension UIView {
    @discardableResult
    func equal(_ attribute: NSLayoutAttribute,
               to view: UIView,
               attribute otherAttribute: NSLayoutAttribute,
               offset: CGFloat? = nil) -> NSLayoutConstraint {
        let constant = offset ?? 0
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: otherAttribute,
                                            multiplier: 1,
                                            constant: constant)
        translatesAutoresizingMaskIntoConstraints = false
        constraint.isActive = true
        
        return constraint
    }
    
    @objc(equal:toValue:)
    @discardableResult
    func equal(_ attribute: NSLayoutAttribute,
               to value: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: value)
        
        translatesAutoresizingMaskIntoConstraints = false
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func equal(_ attribute: NSLayoutAttribute,
               to view: UIView) -> NSLayoutConstraint {
        return self.equal(attribute, to: view, attribute: attribute)
    }
    
    @discardableResult
    func equal(_ attribute: NSLayoutAttribute,
               to view: UIView,
               offset: CGFloat) -> NSLayoutConstraint {
        return self.equal(attribute, to: view, attribute: attribute, offset: offset)
    }
    
    @discardableResult
    func equalSize(to value: CGSize) -> SizeConstraints {
        let width = self.equal(.width, to: value.width)
        let height = self.equal(.height, to: value.height)
        
        return SizeConstraints(width: width, height: height)
    }
    
    func equalSize(to view: UIView) {
        self.equal(.width, to: view)
        self.equal(.height, to: view)
    }
    
    func equalEdges(to view: UIView) {
        self.equal(.left, to: view)
        self.equal(.top, to: view)
        self.equal(.right, to: view)
        self.equal(.bottom, to: view)
    }
}
