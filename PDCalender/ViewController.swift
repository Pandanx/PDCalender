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

    var lastMonthButton: UIButton!
    var nextMonthButton: UIButton!
    var calenderLabel: UILabel!
    var collectionView: UICollectionView!
    var nextCollectionView: UICollectionView!
    var lastCollectionView: UICollectionView!
    var scrollView: UIScrollView!
    var flagContent: CGPoint!
    
    var dateArray: Array<String> = ["日","一","二","三","四","五","六"]
    var currentDay: Int = 0
    var date: Date = Date()
    var monthCount: Int = 0
    var upViewY: CGFloat?
    let calenderIdentifier = "CalendarCell"
    let leftBarButton: UIButton = UIButton()
    let dateIdentifier = "DateCell"
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
        let components = NSCalendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components.day!
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
    
    func nextMonthAction() {
        self.date = self.nextMonth(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
        self.collectionView.reloadData()
    }
    
    func lastMonthAction() {
        self.date = self.lastMonth(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld",self.year(date: self.date),self.month(date: self.date),self.day(date: self.date))
        self.collectionView.reloadData()
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func prepareCollectionView() {
        let itemWidth = kScreenWidth / 7 - 5
        let itemHeight = itemWidth
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let layoutNext = layout
        let layoutLast = layout
        
        lastCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height:400), collectionViewLayout: layoutLast)
        collectionView = UICollectionView.init(frame:  CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height:400), collectionViewLayout: layout)
        nextCollectionView = UICollectionView.init(frame: CGRect(x: kScreenWidth*2, y: 0, width: kScreenWidth, height:400), collectionViewLayout: layoutNext)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        scrollView.addSubview(collectionView)
        
        lastCollectionView.backgroundColor = UIColor.red
        lastCollectionView.dataSource = self
        lastCollectionView.delegate = self
        scrollView.addSubview(lastCollectionView)
        
        nextCollectionView.dataSource = self
        nextCollectionView.delegate = self
        scrollView.addSubview(nextCollectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            let daysInThisMonth = self.totaldaysInThisMonth(date: date)
            let fisrtWeekDay = self.firstWeekdayInThisMoth(date: date)
            var day: Int = 0
            day = daysInThisMonth + fisrtWeekDay
            return day
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lastDate = lastMonth(date: date)
        let nextDate = nextMonth(date: date)

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateIdentifier, for: indexPath) as! DateCell
            cell.backgroundColor = UIColor.orange
            cell.dateString = dateArray[indexPath.row];
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
            if collectionView == self.collectionView {
                let daysInThisMonth = self.totaldaysInThisMonth(date: date)
                let firstWeekday = self.firstWeekdayInThisMoth(date: date)
                var day: Int = 0
                let i = indexPath.item
                cell.backgroundColor = UIColor.lightGray
                if i < firstWeekday {
                    cell.backgroundColor = UIColor.brown
                } else if i > firstWeekday + daysInThisMonth - 1 {
                    cell.backgroundColor = UIColor.red
                } else {
                    if i == currentDay + self.firstWeekdayInThisMoth(date: date) - 1 {
                        cell.backgroundColor = UIColor.gray
                    }
                    
                    day = i - firstWeekday + 1
                    cell.dateString = String(day)
                }
            } else if collectionView == self.nextCollectionView {
                let daysInThisMonth = self.totaldaysInThisMonth(date: nextDate)
                let firstWeekday = self.firstWeekdayInThisMoth(date: nextDate)
                var day: Int = 0
                let i = indexPath.item
                cell.backgroundColor = UIColor.lightGray
                if i < firstWeekday {
                    cell.backgroundColor = UIColor.brown
                } else if i > firstWeekday + daysInThisMonth - 1 {
                    cell.backgroundColor = UIColor.red
                } else {
                    if i == currentDay + self.firstWeekdayInThisMoth(date: nextDate) - 1 {
                        cell.backgroundColor = UIColor.gray
                    }
                    
                    day = i - firstWeekday + 1
                    cell.dateString = String(day)
                }
                
            } else if collectionView == self.lastCollectionView {
                let daysInThisMonth = self.totaldaysInThisMonth(date: lastDate)
                let firstWeekday = self.firstWeekdayInThisMoth(date: lastDate)
                var day: Int = 0
                let i = indexPath.item
                cell.backgroundColor = UIColor.lightGray
                if i < firstWeekday {
                    cell.backgroundColor = UIColor.brown
                } else if i > firstWeekday + daysInThisMonth - 1 {
                    cell.backgroundColor = UIColor.red
                } else {
                    if i == currentDay + self.firstWeekdayInThisMoth(date: lastDate) - 1 {
                        cell.backgroundColor = UIColor.gray
                    }
                    
                    day = i - firstWeekday + 1
                    cell.dateString = String(day)
                }
            }
            
            
            return cell
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
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height:400))
        scrollView.contentSize = CGSize(width:kScreenWidth*3, height: 0)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.contentOffset = CGPoint(x:kScreenWidth, y: 0)
        self.view.addSubview(scrollView)
        
        prepareCollectionView()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
//        tapGesture.delegate = self
//        collectionView.addGestureRecognizer(tapGesture)
//        
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction(_:)))
//        rightSwipe.direction = .right
//        collectionView.addGestureRecognizer(rightSwipe)
//        
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction(_:)))
//        leftSwipe.direction = .left
//        collectionView.addGestureRecognizer(leftSwipe)
        
//        print("\(totaldaysInThisMonth(date: Date()))")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("OFFSETX = \(scrollView.contentOffset.x)")
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        flagContent = scrollView.contentOffset
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.x - flagContent.x > kScreenWidth * 0.5) && (scrollView.contentOffset.x < kScreenWidth * 2) {
            print("NEXT MONTH， OFFSETX = \(scrollView.contentOffset.x)")
            nextMonthAction()
//            self.scrollView.contentOffset = CGPoint(x: kScreenWidth, y:0)
        } else if kScreenWidth - scrollView.contentOffset.x < kScreenWidth*0.5 {
            print("LASt MONTH")
            lastMonthAction()
//            self.scrollView.contentOffset = CGPoint(x: kScreenWidth, y:0)
        }
    }
}
