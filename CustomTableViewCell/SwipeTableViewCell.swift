//
//  SwipeTableViewCell.swift
//  CustomTableViewCell
//
//  Created by Maksim Artemov on 13/04/2018.
//  Copyright © 2018 Maksim Artemov. All rights reserved.
//

let kCellCloseEvent = "SwipeableTableViewCellClose"
let kMaxCloseMilliseconds: CGFloat = 0;
let kOpenVelocityThreshold: CGFloat = 0;

import UIKit

class SwipeTableViewCell: UITableViewCell {
    
    var scrollView: UIScrollView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var closed: Bool {
        return __CGPointEqualToPoint(scrollView.contentOffset, .zero)
    }

    var leftInset: CGFloat {
        return 44.0
    }

    var rightInset: CGFloat {
        return 88.0
    }

    var leftView: UIView {
        return button3
    }

    var rightView: UIView {

        let newFrame = CGRect(x: 0, y: 0, width: button1.frame.width + button2.frame.width, height: button1.frame.width)
        return UIView(frame: newFrame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
        scrollView.contentSize = contentView.bounds.size
        scrollView.contentOffset = .zero

    }
    
    func setUp() {
        
        let scrollView = UIScrollView(frame: self.contentView.bounds)
        scrollView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        scrollView.contentSize = contentView.bounds.size
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.contentInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        contentView.addSubview(scrollView)
        self.scrollView = scrollView
        
        let mainContentView = UIView(frame: scrollView.bounds)
        mainContentView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        mainContentView.backgroundColor = UIColor.red
        scrollView.addSubview(mainContentView)

        NotificationCenter.default.addObserver(self, selector: #selector(handleCloseEvent(notification:)), name: NSNotification.Name(rawValue: kCellCloseEvent), object: nil)
    }
    
    func close() {
        scrollView.setContentOffset(.zero, animated: true)
    }

    @objc func handleCloseEvent(notification: Notification) {
        guard (notification.object as? SwipeTableViewCell) != nil else { return }
        close()
    }
    
    func closeAllCells() {
        closeAllCellsExcept()
    }
    
    func closeAllCellsExcept(cell: UITableViewCell? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCellCloseEvent), object: cell)
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        if sender == self.button1 {
            print("Button 1")
        } else if sender == self.button2 {
            print("Button 2")
        }
    }
    
    deinit {
        print("deallocated")
        NotificationCenter.default.removeObserver(self)
    }

}

extension SwipeTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (leftInset == 0 && scrollView.contentOffset.x < 0) || (rightInset == 0 && scrollView.contentOffset.x > 0) {
            scrollView.contentOffset = .zero
        }

        if scrollView.contentOffset.x < 0 {
            // Make the left buttons stay in place.
//            leftView.frame = CGRect(x: scrollView.contentOffset.x, y: 0, width: leftInset, height: leftView.frame.size.height)
//            leftView.isHidden = false
            // Hide the right buttons.
            rightView.isHidden = true
            button1.isHidden = true
            button2.isHidden = true
        } else if scrollView.contentOffset.x > 0 {
            // Make the right buttons stay in place.
            rightView.frame = CGRect(x: contentView.bounds.width - rightInset + scrollView.contentOffset.x, y: 0, width: rightInset, height: rightView.frame.size.height)
            rightView.isHidden = false
            button1.isHidden = false
            button2.isHidden = false
            // Hide the left buttons.
//            leftView.isHidden = true
        } else {
//            leftView.isHidden = true
            rightView.isHidden = true
            button1.isHidden = true
            button2.isHidden = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("will begin scrolling")

    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = scrollView.contentOffset.x
        let left = leftInset
        let right = rightInset
        
        if left > 0 && (x < -left || (x < 0 && velocity.x < -kOpenVelocityThreshold)) {
            targetContentOffset.pointee.x = -left
        } else if right > 0 && (x > right || (x > 0 && velocity.x > kOpenVelocityThreshold)) {
            targetContentOffset.pointee.x = right
        } else {
            targetContentOffset.pointee = .zero
            
            let ms = x / -velocity.x
            if velocity.x == 0 || ms < 0 || ms > kMaxCloseMilliseconds {
                DispatchQueue.main.async {
                    self.scrollView.setContentOffset(.zero, animated: true)
                }
            }
        }
        
    }
    
}
