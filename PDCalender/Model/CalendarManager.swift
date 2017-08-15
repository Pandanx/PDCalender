//
//  CalendarManager.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/8/14.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import Foundation

struct CalandarManager {
    func day(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.day!
    }
    
    func weekday(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekday, Calendar.Component.day], from: date)
        return components.weekday! - 1
    }
    
    func weekOfMonth(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekOfMonth, Calendar.Component.day], from: date)
        return components.weekOfMonth!
    }
    
    func month(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.month!
    }
    
    func year(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.year!
    }
    //算出每月一号对应星期几
    func firstWeekdayInThisMoth(date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        var component =  calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        component.day = 1
        let firstDayOfMonthDate = calendar.date(from: component)
        let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekDay! - 1
        
    }
    //当前月份天数
    func totaldaysInThisMonth(date: Date) -> Int {
        let totaldaysInMonth: Range = Calendar.current.range(of: .day, in: .month, for: date)!
        //        print("\(totaldaysInMonth)")
        return totaldaysInMonth.upperBound - 1
    }
    
    //上一个月
    func lastMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    //下个月
    func nextMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    
    //上一周
    func lastWeek(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = -7
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    
    //下一周
    func nextWeek(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 7
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        print(day(date: newDate!))
        return newDate!
        
    }
}
