//
//  DateCell.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/7/25.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    var dateLabel: UILabel = UILabel()
    
    var dateString: String? {
        didSet{
            self.dateLabel.text = dateString
            self.dateLabel.textColor = UIColor.lightGray
            self.dateLabel.font = UIFont.systemFont(ofSize: 12)
            self.dateLabel.sizeToFit()
            dateLabel.center.x = self.bounds.width / 2.0
            dateLabel.center.y = self.bounds.height / 2.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.addSubview(dateLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
