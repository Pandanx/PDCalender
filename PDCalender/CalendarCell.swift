//
//  CalendarCell.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/7/25.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    var calendarLabel: UILabel! = UILabel()
    var dateString: String? {
        didSet{
            calendarLabel.text = dateString
            calendarLabel.font = UIFont.systemFont(ofSize: 17)
            calendarLabel.sizeToFit()
            calendarLabel.center.x = self.bounds.width / 2.0
            calendarLabel.center.y = self.bounds.height / 2.0
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(calendarLabel)
        self.layer.cornerRadius = self.frame.width / 2.0
        self.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        dateString = ""
    }
}
