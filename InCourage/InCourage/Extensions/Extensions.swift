//
//  Extensions.swift
//  InCourage
//
//  Created by Eric Andersen on 2/1/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



extension UIView {
    
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}



class SlidetoLeftSegue: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
//        let window = UIApplication.shared.keyWindow
//        window?.insertSubview(dst.view, aboveSubview: src.view)
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0) }, completion: { finished in
                src.present(dst, animated: false, completion: nil)
        })
    }
}
