//
//  ShimmerAnimation.swift
//  MovieList
//
//  Created by Nato Egnatashvili on 3/25/21.
//

import UIKit

class AnimatorView : UIView {
    private let opacityAnimKey = "opacityAnimation"
    
    var startPoint : CGPoint = CGPoint(x: 0, y: 0.5) {
        didSet {
            self.gradientLayer.startPoint = self.startPoint
        }
    }
    
    var endPoint : CGPoint = CGPoint(x: 1, y: 0.5) {
        didSet {
            self.gradientLayer.startPoint = self.startPoint
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func didMoveToWindow() {
        self.layer.addSublayer(self.gradientLayer)
    }
    
    private func configure() {
        self.clipsToBounds = true
        self.gradientLayer.startPoint   = self.startPoint
        self.gradientLayer.endPoint     = self.endPoint
        
    }

    func animateOpacity(beginTime: CFTimeInterval = CACurrentMediaTime(),
                        duration: CFTimeInterval = 2,
                        toValue: CGFloat = 0.3,
                        reversed: Bool = false) {
        
        var animated = false
        if let keys = self.layer.animationKeys() {
            animated = keys.contains(where: { $0 == self.opacityAnimKey })
        }
        
        if !animated {
            let anim = CABasicAnimation(keyPath: "opacity")
            anim.beginTime = beginTime
            anim.fromValue = reversed ? toValue : 1
            anim.toValue = reversed ? 1 : toValue
            anim.duration = duration
            anim.repeatCount = Float.infinity
            anim.autoreverses = true
            anim.accessibilityValue = "opacity"
            self.layer.add(anim, forKey:self.opacityAnimKey)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame.origin.x = -self.bounds.size.width/2
        self.gradientLayer.frame.size.width = self.bounds.size.width/2
        self.gradientLayer.frame.size.height = self.bounds.size.height
    }
}
