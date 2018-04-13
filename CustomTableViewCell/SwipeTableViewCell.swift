//
//  SwipeTableViewCell.swift
//  CustomTableViewCell
//
//  Created by Maksim Artemov on 13/04/2018.
//  Copyright © 2018 Maksim Artemov. All rights reserved.
//

import UIKit

class SwipeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        if sender == self.button1 {
            print("Button 1")
        } else if sender == self.button2 {
            print("Button 2")
        }
    }
}
