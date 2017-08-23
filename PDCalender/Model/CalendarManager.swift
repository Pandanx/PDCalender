//
//  CalendarManager.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/8/14.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import Foundation
public struct CalandarManager {
    public func day(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.day!
    }
    
    public func weekday(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekday, Calendar.Component.day], from: date)
        return components.weekday! - 1
    }
    
    public func weekOfMonth(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekOfMonth, Calendar.Component.day], from: date)
        return components.weekOfMonth!
    }
    
    public func month(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.month!
    }
    
    public func year(date: Date) -> Int {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.year!
    }
    //算出每月一号对应星期几
    public func firstWeekdayInThisMoth(date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        var component =  calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        component.day = 1
        let firstDayOfMonthDate = calendar.date(from: component)
        let firstWeekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekDay! - 1
        
    }
    //当前月份天数
    public func totaldaysInThisMonth(date: Date) -> Int {
        let totaldaysInMonth: Range = Calendar.current.range(of: .day, in: .month, for: date)!
        //        print("\(totaldaysInMonth)")
        return totaldaysInMonth.upperBound - 1
    }
    
    //当前月份有几周
    public func totalweeksInThisMonth(date: Date) -> Int {
        let totaldaysInMonth: Range = Calendar.current.range(of: .weekOfMonth, in: .month, for: date)!
        //        print("\(totaldaysInMonth)")
        return totaldaysInMonth.upperBound - 1
    }
    
    //上一个月
    public func lastMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    //下个月
    public func nextMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    //按需改变月份
    public func changeMonth(date: Date, with count: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = count
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    //上一周
    public func lastWeek(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = -7
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    
    //下一周
    public func nextWeek(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 7
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        print(day(date: newDate!))
        return newDate!
        
    }
}
