//
//  TableDataLabel.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class TableDataLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFontOfSize(16)
        self.textAlignment = .Center
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.5).CGColor
       self.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
