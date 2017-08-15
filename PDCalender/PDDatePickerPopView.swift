//
//  PDDatePicker.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/8/11.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import UIKit

let kDatePickerContentHeight: CGFloat = 310.0
let kDatePickerHeight: CGFloat = 216.0
let kDatePickerPadding: CGFloat = 15.0
typealias DatePickerCallback = ( Date? ) -> Void


class PDDatePickerPopView: UIView {
    
    var datePicker: UIDatePicker!
    var contentView: UIView!
    var titleLabel: UILabel!
    var confirmButton: UIButton!
    var backgroundView: UIView!
    var weekMode: Bool = false
    var weekDatePicker: UIPickerView?
    var callBack: DatePickerCallback?
    
    init() {
        super.init(frame:CGRect.zero)
        prepareViews()
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareViews() {
        contentView = UIView()
        datePicker = UIDatePicker()
        titleLabel = UILabel()
        confirmButton = UIButton(type: .custom)
        self.backgroundColor = UIColor.clear
        
        backgroundView = UIView.init(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.5
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBGView(_:)))
        backgroundView.addGestureRecognizer(tap)
        self.addSubview(backgroundView)
        
        contentView.bounds.size = CGSize(width: kScreenWidth - 30, height: kDatePickerContentHeight)
        contentView.backgroundColor = UIColor.white
        contentView.center = self.backgroundView.center
        self.addSubview(contentView)
        
        
        datePicker.frame.size = CGSize(width: contentView.frame.width - kDatePickerPadding*2, height: kDatePickerHeight)
        datePicker.center = CGPoint(x: contentView.frame.width / 2.0, y: contentView.frame.height / 2.0)
        datePicker.datePickerMode = .date
        contentView.addSubview(datePicker)
        
        titleLabel.text = "选择日期"
        titleLabel.font = UIFont.systemFont(ofSize: 21)
        titleLabel.sizeToFit()
        titleLabel.center.x = datePicker.center.x
        titleLabel.frame.origin.y = datePicker.frame.minY - kDatePickerPadding*2
        contentView.addSubview(titleLabel)
        
        
        
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(UIColor.black, for: .normal)
        confirmButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        confirmButton.sizeToFit()
        confirmButton.center.x = datePicker.center.x
        confirmButton.frame.origin.y = datePicker.frame.maxY
        confirmButton.addTarget(self, action: #selector(confrimAction(_:)), for: .touchUpInside)
        contentView.addSubview(confirmButton)
        
        if weekMode {
            weekDatePicker = UIPickerView.init()
            weekDatePicker?.frame.size = CGSize(width: contentView.frame.width - kDatePickerPadding*2, height: kDatePickerHeight)
            weekDatePicker?.center = CGPoint(x: contentView.frame.width / 2.0, y: contentView.frame.height / 2.0)
            weekDatePicker?.delegate = self
            contentView.addSubview(weekDatePicker!)
        }
    }
    
    class func showDatePicker(_ date: Date, datePickerCallBack: @escaping DatePickerCallback) -> PDDatePickerPopView {
        let datePicker = PDDatePickerPopView()
        let window: UIWindow = UIApplication.shared.keyWindow!
        datePicker.frame = window.bounds
        datePicker.datePicker.date = date
        window.addSubview(datePicker)
        datePicker.callBack = datePickerCallBack
        return datePicker
    }
    
    func tapBGView(_ sender: UITapGestureRecognizer) {
        removeFromSuperview()
    }
    
    func confrimAction(_ sender: UIButton) {
        removeFromSuperview()
        callBack?(self.datePicker.date)
    }
    
}

extension PDDatePickerPopView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}
