//
//  SwipeTableViewCell.swift
//  CustomTableViewCell
//
//  Created by Maksim Artemov on 13/04/2018.
//  Copyright © 2018 Maksim Artemov. All rights reserved.
//

let kCellCloseEvent = "SwipeableTableViewCellClose"


import UIKit

class SwipeTableViewCell: UITableViewCell {

    var panStartPoint: CGPoint?
    var startingRightLayoutConstraintConstant: CGFloat?
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cellMainView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    var closed: Bool {
        return __CGPointEqualToPoint(scrollView.contentOffset, .zero)
    }
    
    var leftInset: CGFloat {
        return 0.0
    }
    
    var rightInset: CGFloat {
        return 0.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func setUp() {
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        NotificationCenter.default.addObserver(self, selector: #selector(handleCloseEvent(notification:)), name: NSNotification.Name(rawValue: kCellCloseEvent), object: nil)
    }
    
    func close() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc func handleCloseEvent(notification: Notification) {
        guard (notification.object as? SwipeTableViewCell) != nil else { return }
        close()
    }


    @IBAction func buttonClicked(_ sender: UIButton) {
        
        if sender == self.button1 {
            print("Button 1")
        } else if sender == self.button2 {
            print("Button 2")
        }
    }


}

extension SwipeTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (leftInset == 0 && scrollView.contentOffset.x < 0) || (rightInset == 0 && scrollView.contentOffset.x > 0) {
            scrollView.contentOffset = .zero
        }
        
        
        
    }
    
}
