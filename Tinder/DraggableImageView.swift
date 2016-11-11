//
//  DraggableImageView.swift
//  Tinder
//
//  Created by Rahul Pandey on 11/10/16.
//  Copyright © 2016 Joomped. All rights reserved.
//

import UIKit

class DraggableImageView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var draggableImage: UIImageView!
    
    var initialCenter: CGPoint!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        print("initSubview")
        // standard initialization logic
        let nib = UINib(nibName: "DraggableImageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: contentView)
        let velocity = sender.velocity(in: contentView)
        
        if sender.state == .began {
            print("began")
            initialCenter = draggableImage.center
        } else if sender.state == .changed {
            draggableImage.center.x = initialCenter.x + translation.x
            let halfWidth = contentView.frame.width / CGFloat(2)
            let distanceMoved = CGFloat(translation.x)
            let degreesRotated = 45 * (distanceMoved / halfWidth)
            print("degrees to rotate: \(degreesRotated)")
            var rotationAmount = degreesToRadians(degrees: Int(degreesRotated))
            if initialCenter.y >= draggableImage.frame.height / CGFloat(2) {
                rotationAmount *= -1
            }
            if velocity.x < 0 {
                // rotate counterclockwise
                rotationAmount *= -1
            }
            draggableImage.transform = transform.rotated(by: rotationAmount)
        } else if sender.state == .ended {
            print("ended")
            if translation.x > 50 {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.draggableImage.center.x = self.contentView.frame.maxX + self.draggableImage.frame.width
                })
            } else if translation.x < -50 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.draggableImage.center.x = -(self.contentView.frame.maxX + self.draggableImage.frame.width)
                })
            } else {
                draggableImage.center = initialCenter
                draggableImage.transform = CGAffineTransform.identity
            }
        }
    }
    
    func degreesToRadians(degrees: Int) -> CGFloat {
        return CGFloat(degrees) / CGFloat(180.0) * CGFloat(M_PI)
    }

}
