//
//  TableLabel.swift
//  
//
//  Created by Qinyuan Liu on 12/19/16.
//
//

import UIKit

class TableLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.boldSystemFontOfSize(18)
        self.textAlignment = .Center
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).CGColor
        self.backgroundColor = UIColor(red: 190/255, green: 236/255, blue: 255/255, alpha: 1)
        

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
