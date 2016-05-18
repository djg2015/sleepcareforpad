//
//  AlarmTableViewCell.swift
//  ewell.sleepcareforpad
//
//  Created by zhaoyin on 15/10/13.
//  Copyright (c) 2015年 djg. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCellLeaveTimespan: UILabel!
   
    @IBOutlet weak var lblCellLeaveTime: UILabel!
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    
        self.frame.size.width =  UIScreen.mainScreen().bounds.width - 70

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
