//
//  ViewController.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/7/24.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kHeightRation = kScreenHeight / 670.0
let kWidthRation = kScreenWidth / 375.0

let kButtonWidth: CGFloat = 80.0
let kButtonHeight: CGFloat = 40.0
let kHorizontailyPadding: CGFloat = 20.0
let kVerticalPading: CGFloat = 100.0

class ViewController: UIViewController {
    
    var calenderCellColor: UIColor?
    var selectedCellColor: UIColor?
    var tadayCellColor: UIColor?
    var weekMode: Bool = false

    var lastMonthButton: UIButton!
    var nextMonthButton: UIButton!
    var calenderLabel: UILabel!
    var collectionView: UICollectionView!
    var nextCollectionView: UICollectionView!
    var lastCollectionView: UICollectionView!
    var scrollView: UIScrollView!
    var flagContent: CGPoint!
    
    var itemHeight: CGFloat = kScreenWidth / 7 - 5
    var itemWidth: CGFloat = kScreenWidth / 7 - 5
    
    var dateArray: Array<String> = ["日","一","二","三","四","五","六"]
    var currentDay: Int = 0
    var date: Date = Date()
    var monthCount: Int = 0
    var upViewY: CGFloat?
    let calenderIdentifier = "CalendarCell"
    let dateIdentifier = "DateCell"
    let leftBarButton: UIButton = UIButton()
    let animationController: CalenderAnimationCotroller = CalenderAnimationCotroller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addViews()
        collectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: calenderIdentifier)
        collectionView.register(DateCell.classForCoder(), forCellWithReuseIdentifier: dateIdentifier)
        nextCollectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: calenderIdentifier)
        nextCollectionView.register(DateCell.classForCoder(), forCellWithReuseIdentifier: dateIdentifier)
        lastCollectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: calenderIdentifier)
        lastCollectionView.register(DateCell.classForCoder(), forCellWithReuseIdentifier: dateIdentifier)
        currentDay = self.day(date: date)
        prepareNavigationBar()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        collectionView.reloadData()
    }
    func prepareNavigationBar() {
        let item = UIBarButtonItem(title: String(format:"%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date)), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        item.tintColor = UIColor.orange
        self.navigationItem.leftBarButtonItem=item
    }
    func addViews() {
        prepareScrollView()
    }
    
   
    
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
        monthCount -= 1
        let newDate = Calendar.current.date(byAdding: dateComponents, to: date)
        return newDate!
    }
    //下个月
    func nextMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        monthCount += 1
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
    
    func rightSwipeAction(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(with: self.collectionView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.date = self.lastMonth(date: self.date)
            self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
            
        }, completion: nil)
        self.collectionView.reloadData()
        
    }
    func leftSwipeAction(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(with: collectionView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.date = self.nextMonth(date: self.date)
            self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
            
        }, completion: nil)
        self.collectionView.reloadData()
    }
    
    func upSwipeAction(_ sender: UISwipeGestureRecognizer) {
        if !weekMode {
            weekMode = true
            collectionView.reloadData()
            nextCollectionView.reloadData()
            lastCollectionView.reloadData()
        }
    }
    
    func downSwipeAction(_ sender: UISwipeGestureRecognizer) {
        if weekMode {
            weekMode = false
            collectionView.reloadData()
            nextCollectionView.reloadData()
            lastCollectionView.reloadData()
        }
    }
    
    func nextMonthAction() {
        self.date = self.nextMonth(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
        self.collectionView.reloadData()
        self.lastCollectionView.reloadData()
        self.nextCollectionView.reloadData()
    }
    
    func lastMonthAction() {
        self.date = self.lastMonth(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
        self.collectionView.reloadData()
        self.lastCollectionView.reloadData()
        self.nextCollectionView.reloadData()
    }
    
    func nextWeekAction() {
        self.date = self.nextWeek(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
        self.collectionView.reloadData()
        self.lastCollectionView.reloadData()
        self.nextCollectionView.reloadData()
    }
    
    func lastWeekAction() {
        self.date = self.lastWeek(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
        self.collectionView.reloadData()
        self.lastCollectionView.reloadData()
        self.nextCollectionView.reloadData()
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: itemWidth, height: 20)
        } else {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let layoutNext = UICollectionViewFlowLayout()
        layoutNext.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layoutNext.minimumLineSpacing = 2
        layoutNext.minimumInteritemSpacing = 2
        let layoutLast = UICollectionViewFlowLayout()
        layoutLast.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layoutLast.minimumLineSpacing = 2
        layoutLast.minimumInteritemSpacing = 2
        
        lastCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height:500), collectionViewLayout: layoutLast)
        collectionView = UICollectionView.init(frame:  CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height:500), collectionViewLayout: layout)
        nextCollectionView = UICollectionView.init(frame: CGRect(x: kScreenWidth*2, y: 0, width: kScreenWidth, height:500), collectionViewLayout: layoutNext)
        
        let upSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(upSwipeAction(_:)))
        upSwipe.direction = .down
        collectionView.addGestureRecognizer(upSwipe)
        
        let downSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(downSwipeAction(_:)))
        upSwipe.direction = .up
        collectionView.addGestureRecognizer(downSwipe)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        scrollView.addSubview(collectionView)
        
        lastCollectionView.dataSource = self
        lastCollectionView.delegate = self
        scrollView.addSubview(lastCollectionView)
        
        nextCollectionView.dataSource = self
        nextCollectionView.delegate = self
        scrollView.addSubview(nextCollectionView)
        
        collectionView.backgroundColor = UIColor.white
        nextCollectionView.backgroundColor = UIColor.white
        lastCollectionView.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            
            let lastDate = lastMonth(date: date)
            let nextDate = nextMonth(date: date)
            var day: Int = 0
            if weekMode {
                return 7
            } else {
                if collectionView == lastCollectionView {
                    
                    let daysInThisMonth = self.totaldaysInThisMonth(date: lastDate)
                    let fisrtWeekDay = self.firstWeekdayInThisMoth(date: lastDate)
                    day = daysInThisMonth + fisrtWeekDay
                } else if collectionView == self.collectionView {
                    let daysInThisMonth = self.totaldaysInThisMonth(date: date)
                    let fisrtWeekDay = self.firstWeekdayInThisMoth(date: date)
                    day = daysInThisMonth + fisrtWeekDay
                } else if collectionView == nextCollectionView {
                    let daysInThisMonth = self.totaldaysInThisMonth(date: nextDate)
                    let fisrtWeekDay = self.firstWeekdayInThisMoth(date: nextDate)
                    day = daysInThisMonth + fisrtWeekDay
                }
                return day
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lastDate = lastMonth(date: date)
        let nextDate = nextMonth(date: date)
        let lastWeekDate = lastWeek(date: date)
        let nextWeekDate = nextWeek(date: date)

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateIdentifier, for: indexPath) as! DateCell
            cell.backgroundColor = UIColor.white
            cell.dateString = dateArray[indexPath.row];
            return cell
        } else {
            if collectionView == self.collectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
                if weekMode {
    
                    let weekday = self.weekday(date: date)
                    let flag = self.day(date: date) - weekday
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i == weekday {
                        if weekOfMonth(date: date) == weekOfMonth(date: Date()) {
                            cell.backgroundColor = UIColor.red
                        }
                    }
                    day = flag + i
                    
                    if day > 0 && day < self.totaldaysInThisMonth(date: date) {
                        cell.dateString = String(day)
                    }
                } else {
                    
                    let daysInThisMonth = self.totaldaysInThisMonth(date: date)
                    let firstWeekday = self.firstWeekdayInThisMoth(date: date)
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i < firstWeekday {
                        //                    cell.backgroundColor = UIColor.brown
                    } else if i > firstWeekday + daysInThisMonth - 1 {
                        //                    cell.backgroundColor = UIColor.red
                    } else {
                        print("CurrentDay = \(currentDay), FirstWeekDay = \(self.firstWeekdayInThisMoth(date: date))")
                        if i == currentDay + self.firstWeekdayInThisMoth(date: date) - 1 {
                            if month(date: date) == month(date: Date()) {
                                cell.backgroundColor = UIColor.red
                            }
                            
                        }
                        
                        day = i - firstWeekday + 1
                        cell.dateString = String(day)
                    }

                }
                return cell
            } else if collectionView == self.nextCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
                if weekMode {
                    let weekday = self.weekday(date: nextWeekDate)
                    let flag = self.day(date: nextWeekDate) - weekday
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i == weekday {
                        print("currentWeek = \(weekOfMonth(date: Date())) nextweek = \(weekOfMonth(date: nextWeekDate))")
                        if weekOfMonth(date: nextWeekDate) == weekOfMonth(date: Date()) {
                            cell.backgroundColor = UIColor.red
                        }
                    }
                    day = flag + i
                    
                    if day > 0 && day < self.totaldaysInThisMonth(date: nextDate) {
                        cell.dateString = String(day)
                    }
                } else {
                    let daysInThisMonth = self.totaldaysInThisMonth(date: nextDate)
                    let firstWeekday = self.firstWeekdayInThisMoth(date: nextDate)
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i < firstWeekday {
                        
                    } else if i > firstWeekday + daysInThisMonth - 1 {
                        
                    } else {
                        day = i - firstWeekday + 1
                        cell.dateString = String(day)
                    }
                }
                return cell
            } else if collectionView == self.lastCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
                if weekMode {
                    let weekday = self.weekday(date: lastWeekDate)
                    let flag = self.day(date: lastWeekDate) - weekday
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i == weekday {
                        if weekOfMonth(date: lastWeekDate) == weekOfMonth(date: Date()) {
                            cell.backgroundColor = UIColor.red
                        }
                    }
                    day = flag + i

                    if day > 0 && day < self.totaldaysInThisMonth(date: lastDate) {
                        cell.dateString = String(day)
                    }
                } else {
                    
                    let daysInThisMonth = self.totaldaysInThisMonth(date: lastDate)
                    let firstWeekday = self.firstWeekdayInThisMoth(date: lastDate)
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i < firstWeekday {
                        
                    } else if i > firstWeekday + daysInThisMonth - 1 {
                        
                    } else {
                        day = i - firstWeekday + 1
                        cell.dateString = String(day)
                    }
                }
            
                return cell
            } else {
                return UICollectionViewCell()
            }
        
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
extension ViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.reverse = (operation == UINavigationControllerOperation.pop)
        animationController.upViewY = upViewY
        return animationController
    }
}
extension ViewController: UIGestureRecognizerDelegate {
    func tapGestureAction(_ gesture: UITapGestureRecognizer){
        let location = gesture.location(in: self.view)
        upViewY = location.y
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let testVC:TestViewController = storyboard.instantiateViewController(withIdentifier: "textViewController") as! TestViewController
        navigationController?.pushViewController(testVC, animated: true);
        
    }
}
extension ViewController: UIScrollViewDelegate {
    
    func prepareScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height:500))
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width:kScreenWidth*3, height: 0)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentOffset = CGPoint(x:kScreenWidth, y: 0)
        self.view.addSubview(scrollView)
        
        prepareCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tapGesture.delegate = self
        collectionView.addGestureRecognizer(tapGesture)
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("1111111")
        if scrollView.contentOffset.x == 2*kScreenWidth {
            print("Right Swipe")
            weekMode ? nextWeekAction() : nextMonthAction()
            
        }
        if scrollView.contentOffset.x == 0 {
            print("Left Swipe")
            weekMode ? lastWeekAction() : lastMonthAction()

        }
        self.scrollView.contentOffset = CGPoint(x: kScreenWidth , y:self.scrollView.contentOffset.y)
    }
}
