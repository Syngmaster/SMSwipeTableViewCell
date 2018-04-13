//
//  SwipeTableViewCell.swift
//  CustomTableViewCell
//
//  Created by Maksim Artemov on 13/04/2018.
//  Copyright © 2018 Maksim Artemov. All rights reserved.
//

import UIKit

class SwipeTableViewCell: UITableViewCell {
    
    var panRecognizer: UIPanGestureRecognizer {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panThisCell(recognizer:)))
        return recognizer
    }
    var panStartPoint: CGPoint?
    var startingRightLayoutConstraintConstant: CGFloat?
    @IBOutlet weak var contentViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var myContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        panRecognizer.delegate = self
        myContentView.addGestureRecognizer(panRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func panThisCell(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            panStartPoint = recognizer.translation(in: myContentView)
            print("pan began at \(NSStringFromCGPoint(panStartPoint!))")
        case .changed:
            let currentPoint = recognizer.translation(in: myContentView)
            let deltaX = currentPoint.x - panStartPoint!.x
            print("pan moved \(deltaX))")
        case .ended:
            print("pan ended at")
        case .cancelled:
            print("pan cancelled")
        default: break
        }
        
        
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        if sender == self.button1 {
            print("Button 1")
        } else if sender == self.button2 {
            print("Button 2")
        }
    }
}
