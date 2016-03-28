//
//  TileView.swift
//  Match The Tiles
//
//  Created by Zhe Xian Lee on 28/03/2016.
//  Copyright © 2016 Zhe Xian Lee. All rights reserved.
//

import UIKit

protocol TileViewDelegate {
    func didSelectTile(tileView: TileView)
}

class TileView: UIView {
    
    var delegate : TileViewDelegate?
    var tileIndex : Int?
    
    var tileImage : UIImage? {
        didSet {
            tileImageView?.image = tileImage
        }
    }
    var tileImageView : UIImageView?
    var tileImageViewConstraintCenterX: NSLayoutConstraint?
    var tileImageViewConstraintCenterY: NSLayoutConstraint?
    var tileImageViewConstraintHeight : NSLayoutConstraint?
    var tileImageViewConstraintWidthExpanded : NSLayoutConstraint?
    var tileImageViewConstraintWidthCollapsed : NSLayoutConstraint?
    
    var questionImage : UIImage?
    var questionImageView : UIImageView?
    var questionImageViewConstraintCenterX: NSLayoutConstraint?
    var questionImageViewConstraintCenterY : NSLayoutConstraint?
    var questionImageViewConstraintHeight : NSLayoutConstraint?
    var questionImageViewConstraintWidthExpanded : NSLayoutConstraint?
    var questionImageViewConstraintWidthCollapsed : NSLayoutConstraint?
    
    var isImageCovered : Bool?
    var isTileHidden : Bool?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize the 'question mark" image
        questionImage = UIImage(named: "question")
        questionImageView = UIImageView(image: questionImage)
        questionImageView?.contentMode = .ScaleAspectFill
        questionImageView?.clipsToBounds = true
        questionImageView?.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(questionImageView!)

        questionImageViewConstraintCenterX = NSLayoutConstraint(item: questionImageView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        questionImageViewConstraintCenterY = NSLayoutConstraint(item: questionImageView!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        questionImageViewConstraintHeight = NSLayoutConstraint(item: questionImageView!, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: -8)
        questionImageViewConstraintWidthExpanded = NSLayoutConstraint(item: questionImageView!, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -8)
        questionImageViewConstraintWidthCollapsed = NSLayoutConstraint(item: questionImageView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
       
        questionImageViewConstraintCenterX?.priority = 1000
        questionImageViewConstraintCenterY?.priority = 1000
        questionImageViewConstraintHeight?.priority = 1000
        questionImageViewConstraintWidthExpanded?.priority = 999
        questionImageViewConstraintWidthCollapsed?.priority = 1
        
        self.addConstraints([
            questionImageViewConstraintCenterX!,
            questionImageViewConstraintCenterY!,
            questionImageViewConstraintHeight!,
            questionImageViewConstraintWidthExpanded!,
            questionImageViewConstraintWidthCollapsed!
        ])
        
        
        // Initialize the tile image
        tileImageView = UIImageView()
        tileImageView?.contentMode = .ScaleAspectFill
        tileImageView?.clipsToBounds = true
        tileImageView?.translatesAutoresizingMaskIntoConstraints = false
        tileImageView?.alpha = 0
        
        self.addSubview(tileImageView!)
        
        tileImageViewConstraintCenterX = NSLayoutConstraint(item: tileImageView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0)
        tileImageViewConstraintCenterY = NSLayoutConstraint(item: tileImageView!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
        tileImageViewConstraintHeight = NSLayoutConstraint(item: tileImageView!, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: -8)
        tileImageViewConstraintWidthExpanded = NSLayoutConstraint(item: tileImageView!, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -8)
        tileImageViewConstraintWidthCollapsed = NSLayoutConstraint(item: tileImageView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0)
        
        tileImageViewConstraintCenterX?.priority = 1000
        tileImageViewConstraintCenterY?.priority = 1000
        tileImageViewConstraintHeight?.priority = 1000
        tileImageViewConstraintWidthExpanded?.priority = 1
        tileImageViewConstraintWidthCollapsed?.priority = 999
        
        self.addConstraints([
            tileImageViewConstraintCenterX!,
            tileImageViewConstraintCenterY!,
            tileImageViewConstraintHeight!,
            tileImageViewConstraintWidthExpanded!,
            tileImageViewConstraintWidthCollapsed!
        ])
        
        isImageCovered = true
        isTileHidden = false
        
        // Setup gesture recognisers
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTapGesture:"))
        
    }
    
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if (sender.state == .Ended && !isTileHidden!) {
            self.flipTile()
            self.delegate?.didSelectTile(self);
        }
    }
    
    
    func flipTile(delay: NSTimeInterval = 0) {
            self.isImageCovered = !self.isImageCovered!
            questionImageViewConstraintWidthExpanded?.priority = questionImageViewConstraintWidthExpanded?.priority == 999 ? 1 : 999
            questionImageViewConstraintWidthCollapsed?.priority = questionImageViewConstraintWidthCollapsed?.priority == 999 ? 1 : 999
            tileImageViewConstraintWidthExpanded?.priority = tileImageViewConstraintWidthExpanded?.priority == 999 ? 1 : 999;
            tileImageViewConstraintWidthCollapsed?.priority = tileImageViewConstraintWidthCollapsed?.priority == 999 ? 1 : 999;
            
            UIView.animateWithDuration(1.5, delay: delay, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .TransitionNone, animations: { () -> Void in
                self.questionImageView?.alpha = self.questionImageView?.alpha == 0 ? 1 : 0;
                self.tileImageView?.alpha = self.tileImageView?.alpha == 0 ? 1 : 0;
                self.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func resetTile() {
        coverImage()
        isTileHidden = false
    }
    
    func coverImage(delay: NSTimeInterval = 0) {
        questionImageViewConstraintWidthExpanded?.priority = 999
        questionImageViewConstraintWidthCollapsed?.priority = 1
        tileImageViewConstraintWidthExpanded?.priority = 1
        tileImageViewConstraintWidthCollapsed?.priority = 999
        
        UIView.animateWithDuration(1.5, delay: delay, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .TransitionNone, animations: { () -> Void in
            self.questionImageView?.alpha = 1;
            self.tileImageView?.alpha = 0;
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func hideTile(delay: NSTimeInterval = 0) {
        isTileHidden = true
        questionImageViewConstraintWidthExpanded?.priority = 1
        questionImageViewConstraintWidthCollapsed?.priority = 999
        tileImageViewConstraintWidthExpanded?.priority = 1
        tileImageViewConstraintWidthCollapsed?.priority = 999
        
        UIView.animateWithDuration(1.5, delay: delay, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .TransitionNone, animations: { () -> Void in
            self.questionImageView?.alpha = 0
            self.tileImageView?.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
    }

    
    
}
