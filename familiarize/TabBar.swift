//
//  ExampleIrregularityContentView.swift
//  ESTabBarControllerExample
//
//  Created by lihao on 2017/2/9.
//  Copyright © 2017年 Vincent Li. All rights reserved.
//

import UIKit
import pop
import ESTabBarController_swift

class ExampleBasicContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(red: 193/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        iconColor = UIColor.init(red: 193/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        backgroundColor = UIColor.init(white: 200.0 / 255.0, alpha: 1.0)
        backdropColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExampleBouncesContentView: ExampleBasicContentView {
    
    public var duration = 0.15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.2, 0.95, 1.05, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = kCAAnimationCubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}

class ExampleIrregularityBasicContentView: ExampleBouncesContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(red: 193/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        iconColor = UIColor.init(red: 193/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0)
        backdropColor = .clear
        highlightBackdropColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExampleIrregularityContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.imageView.image = UIImage(named: "dan_camera_round")
        //self.imageView.backgroundColor = UIColor.white
//        self.imageView.layer.borderWidth = 2
//        self.imageView.layer.borderColor = UIColor.init(red: 47/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1.0).cgColor
//        self.imageView.layer.cornerRadius = 60
        self.insets = UIEdgeInsetsMake(-16, 0, 0, 0)
        self.superview?.bringSubview(toFront: self)
        //let transform = CGAffineTransform.identity
        //self.imageView.transform = transform
        //self.superview?.bringSubview(toFront: self)
        
        //textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        //highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        //iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        //highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        //backdropColor = .clear
        //highlightBackdropColor = .clear
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }
    
    public override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 2.0, height: 2.0)))
        view.layer.cornerRadius = 1.0
        //view.layer.opacity = 0.5
        view.backgroundColor = UIColor.init(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
        self.addSubview(view)
        playMaskAnimation(animateView: view, target: self.imageView, completion: {
            [weak view] in
            view?.removeFromSuperview()
            completion?()
        })
    }
    
    public override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    public override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.1)
        let transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.1)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }
    
    private func playMaskAnimation(animateView view: UIView, target: UIView, completion: (() -> ())?) {
        view.center = CGPoint.init(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)
        
        let scale = POPBasicAnimation.init(propertyNamed: kPOPLayerScaleXY)
        scale?.fromValue = NSValue.init(cgSize: CGSize.init(width: 1.0, height: 1.0))
        scale?.toValue = NSValue.init(cgSize: CGSize.init(width: 36.0, height: 36.0))
        scale?.beginTime = CACurrentMediaTime()
        scale?.duration = 0.15
        scale?.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        scale?.removedOnCompletion = true
        
        let alpha = POPBasicAnimation.init(propertyNamed: kPOPLayerOpacity)
        alpha?.fromValue = 0.6
        alpha?.toValue = 0.6
        alpha?.beginTime = CACurrentMediaTime()
        alpha?.duration = 0.1
        alpha?.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        alpha?.removedOnCompletion = true
        
        view.layer.pop_add(scale, forKey: "scale")
        view.layer.pop_add(alpha, forKey: "alpha")
        
        scale?.completionBlock = ({ animation, finished in
            completion?()
        })
    }

}
